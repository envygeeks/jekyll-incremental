# rubocop:disable Naming/FileName
# Frozen-string-literal: true
# Copyright: 2017 - Apache 2.0 License
# Encoding: utf-8

require "jekyll/cache"

module Jekyll
  # --
  # @note we replace theirs in-place.
  # @example bundle exec jekyll b --incremental
  # A replacement of Jekyll's Regenerator.  That does a
  #   few things a bit differently, most things.
  # --
  module Incremental
    FORCE_KEYS = %w(regenerate force force_regenerate regen).freeze
    CACHE_KEY  = "jekyll:regenerator:metadata"

    def disabled?
      !site.incremental? || (site.config.key?("incremental") &&
          !site.config["incremental"])
    end

    # --
    # {
    #   <Filename> => {
    #     last_modified => Time.now,
    #     forced => true|false
    #     dependencies => [
    #       <FileName>
    #     ]
    #   }
    # }
    # --
    # Determines if a file should be regenerated or not,
    #   this is determined by a few key things, such as whether
    #   you force it by metadata inside of your file, or
    #   whether the file has been modified.
    # --
    def regenerate?(doc)
      out = false unless doc.write?
      out = true if doc.respond_to?(:asset_file?) && doc.asset_file?
      out = true if forced_by_data?(doc)
      out = modified?(doc)

      out
    end

    # --
    # They are one in the same now, there is no reason to
    #   have something that is different.  These still exist
    #   for people who manually call this stuff.
    # --
    alias regenerate_page? regenerate?
    alias regenerate_document? regenerate?
    alias regenerate_doc? regenerate?

    # --
    def forced_by_data?(doc)
      doc.data.values_at(FORCE_KEYS)
        .include?(true)
    end

    # --
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/LineLength
    # rubocop:disable Metrics/AbcSize
    # --
    def modified?(doc)
      return true if metadata[doc.path]&.[](:forced)
      return true unless File.exist?(site.in_dest_dir(doc.path))
      modified, hash = file_mtime_of(doc.path), metadata[doc.path]
      return modified > hash[:last_modified] if hash && !hash[:dynamic] && hash[:seen_before]
      return hash[:seen_before] = true if hash && !hash[:seen_before]
      return dependencies_modified?(hash) if hash
      add(doc.path).update(seen_before: true)

      true
    end

    # --
    def dependencies_modified?(path)
      path[:dependencies].map { |v| modified?(v) }
        .include?(true)
    end

    # --
    # They are one in the same now, there is no reason to
    #   have something that is different as we will eventually
    #   call this anyways.
    # --
    alias existing_file_modified? modified?
    alias source_modified_or_dest_missing? \
      modified?

    # --
    def file_mtime_of(path)
      File.exist?(path) ? File.mtime(path) : Time.now
    end

    # --
    # seen_before address a logical race that happens
    #   incide of Jekyll.  Dependencies are added before
    #   dependents, which is not good at all.
    # --
    def add(path, forced: false)
      return metadata[path] if metadata.key?(path)
      metadata[path] = {
        seen_before: false,
        dynamic: !File.exist?(site.in_source_dir(path)),
        last_modified: file_mtime_of(path),
        dependencies: Set.new,
        forced: forced,
      }
    end

    # --
    def add_dependency(path, dependency)
      add(path).fetch(:dependencies) << dependency
    end

    # --
    def force(path)
      add(path, {
        force: true,
      })
    end

    # --
    def metadata
      @metadata ||= Jekyll.cache.fetch(CACHE_KEY) do
        {}
      end
    end

    # --
    # They are one in the same now, there is no reason to
    #   have something that is different as we will eventually
    #   write it anyways.  Seems redundant.
    # --
    alias cache metadata

    # --
    def clear
      @metadata = nil
      Jekyll.cache.delete(CACHE_KEY)
      metadata
    end

    # --
    # Write the metadata into the Jekyll cache.
    # @return [nil]
    # --
    def write_metadata
      unless disabled?
        Jekyll.cache.write(CACHE_KEY,
          cache)
      end
    end

    # --
    # Not used anymore, so we just nil them out.
    # If they do then we'll readd them properly someway.
    # These shouldn't cause problems.
    # --
    %i(clear_cache read_metadata).each do |v|
      define_method v do |*|
        nil
      end
    end

    # --
    def metadata_file
      site.in_source_dir(".jekyll-metadata")
    end
  end
end

# --
module Jekyll
  # --
  # Patches Jekyll's own regenerator, and replaces it with
  #   our regenerator, which should in theory be more efficient
  #   than Jekyll's since it does less work.
  # --
  class Regenerator
    prepend Jekyll::Incremental
  end
end

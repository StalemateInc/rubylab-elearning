module Intersectable
  def intersect(source_hash, target_hash)
    target_clone = target_hash.clone.keep_if { |key, _value| source_hash.key? key }
    source_hash.merge(target_clone)
  end
end


def require_many paths
  paths.each { |path| require path unless path[0] == '#' }
end



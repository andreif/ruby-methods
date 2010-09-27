# def require_relative *paths
#   p __FILE__
#   pwd = File.dirname(__FILE__)
#   paths.flatten.each { |path| require pwd + '/' + path }
# end
def require_relative *paths
  paths.flatten.each do |path|
    #pp File.join( File.dirname( Kernel.caller[2] ), path.to_str )
    require File.join File.dirname( Kernel.caller[2] ), path.to_str
  end
end
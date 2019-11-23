module KoalaAdapter

  def get_me
    get_object('me')
  end

  private

  def fbgraph
    @fbgraph ||= Koala::Facebook::API.new(@token)
  end

  def get_object(id, args = {}, options = {}, &block)
    fbgraph.get_object(id, args, options, &block)
  end

  def get_connections(id, connection_name, args = {}, options = {}, &block)
    fbgraph.get_connections(id, connection_name, args, options, &block)
  end

end
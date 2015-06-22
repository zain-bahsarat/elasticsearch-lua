-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Settings = require "Settings"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Client = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The Settings instance
Client.settings = nil

-------------------------------------------------------------------------------
-- Function to get an endpoint instance for a particular type of request
--
-- @param   endpoint  The string denoting the endpoint
--
-- @return  Endpoint  The endpoint object
-------------------------------------------------------------------------------
function Client:getEndpoint(endpoint)
  local Endpoint = require("endpoints." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.settings.transport
  }
  return endpoint
end

-------------------------------------------------------------------------------
-- Function to get information regarding the Elasticsearch server
--
-- @return   table     The details about the elasticsearch server as lua-table
-------------------------------------------------------------------------------
function Client:info()
  local endpoint = self:getEndpoint("Info")
  return endpoint:request().body
end

-------------------------------------------------------------------------------
-- Function to get a particular document
--
-- @param    params    The search Parameters
--
-- @return   table     The document
-------------------------------------------------------------------------------
function Client:get(params)
  local endpoint = self:getEndpoint("Get")
  endpoint.id = params.id
  endpoint.index = params.index
  endpoint.type = params.type
  params.id, params.index, params.type = nil, nil, nil
  endpoint.params = params
  return endpoint:request().body
end

-------------------------------------------------------------------------------
-- Function to index a particular document
--
-- @param    params    The index Parameters
--
-- @return   table     The document
-------------------------------------------------------------------------------
function Client:index(params)
  local endpoint = self:getEndpoint("Index")
  endpoint.id = params.id
  endpoint.index = params.index
  endpoint.type = params.type
  endpoint.body = params.body
  params.id, params.index, params.type, params.body = nil, nil, nil, nil
  endpoint.params = params
  return endpoint:request().body
end

-------------------------------------------------------------------------------
-- Returns an instance of Client class
-------------------------------------------------------------------------------
function Client:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.settings = Settings:new({
    hosts = o.hosts,
    settings = o.params
  })
  return o
end

return Client
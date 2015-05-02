# -*- coding:binary -*-
require 'spec_helper'

require 'rex/java/serialization'
require 'rex/proto/rmi'
require 'msf/java/rmi/client'

describe Msf::Java::Rmi::Client::Jmx::Server::Parser do
  subject(:mod) do
    mod = ::Msf::Exploit.new
    mod.extend ::Msf::Java::Rmi::Client
    mod.send(:initialize)
    mod
  end

  let(:new_client_return) do
    raw = "\xac\xed\x00\x05\x77\x0f\x01\x82\x73\x92\x35\x00\x00\x01\x4c\x48" +
      "\x27\x84\x49\x80\xb8\x73\x72\x00\x32\x6a\x61\x76\x61\x78\x2e\x6d" +
      "\x61\x6e\x61\x67\x65\x6d\x65\x6e\x74\x2e\x72\x65\x6d\x6f\x74\x65" +
      "\x2e\x72\x6d\x69\x2e\x52\x4d\x49\x43\x6f\x6e\x6e\x65\x63\x74\x69" +
      "\x6f\x6e\x49\x6d\x70\x6c\x5f\x53\x74\x75\x62\x00\x00\x00\x00\x00" +
      "\x00\x00\x02\x02\x00\x00\x70\x78\x72\x00\x1a\x6a\x61\x76\x61\x2e" +
      "\x72\x6d\x69\x2e\x73\x65\x72\x76\x65\x72\x2e\x52\x65\x6d\x6f\x74" +
      "\x65\x53\x74\x75\x62\xe9\xfe\xdc\xc9\x8b\xe1\x65\x1a\x02\x00\x00" +
      "\x70\x78\x72\x00\x1c\x6a\x61\x76\x61\x2e\x72\x6d\x69\x2e\x73\x65" +
      "\x72\x76\x65\x72\x2e\x52\x65\x6d\x6f\x74\x65\x4f\x62\x6a\x65\x63" +
      "\x74\xd3\x61\xb4\x91\x0c\x61\x33\x1e\x03\x00\x00\x70\x78\x70\x77" +
      "\x37\x00\x0a\x55\x6e\x69\x63\x61\x73\x74\x52\x65\x66\x00\x0e\x31" +
      "\x37\x32\x2e\x31\x36\x2e\x31\x35\x38\x2e\x31\x33\x32\x00\x00\x13" +
      "\x26\x08\xd9\x72\x63\x38\x4c\x6b\x7c\x82\x73\x92\x35\x00\x00\x01" +
      "\x4c\x48\x27\x84\x49\x80\xb7\x01\x78"
    io = StringIO.new(raw, 'rb')
    rv = Rex::Proto::Rmi::Model::ReturnValue.new
    rv.decode(io)

    rv
  end

  let(:remote_object) { 'javax.management.remote.rmi.RMIConnectionImpl_Stub' }
  let(:remote_interface) do
    {
      address: '172.16.158.132',
      port: 4902,
      object_number: 637666592721496956
    }
  end

  describe "#parse_jmx_new_client_endpoint" do
    it "returns the remote reference information in a Hash" do
      expect(mod.parse_jmx_new_client_endpoint(new_client_return)).to be_a(Hash)
    end

    it "returns the remote address" do
      ref = mod.parse_jmx_new_client_endpoint(new_client_return)
      expect(ref[:address]).to eq(remote_interface[:address])
    end

    it "returns the remote port" do
      ref = mod.parse_jmx_new_client_endpoint(new_client_return)
      expect(ref[:port]).to eq(remote_interface[:port])
    end

    it "returns the remote object number" do
      ref = mod.parse_jmx_new_client_endpoint(new_client_return)
      expect(ref[:object_number]).to eq(remote_interface[:object_number])
    end

    it "returns the remote object unique identifier" do
      ref = mod.parse_jmx_new_client_endpoint(new_client_return)
      expect(ref[:uid]).to be_a(Rex::Proto::Rmi::Model::UniqueIdentifier)
    end
  end
end


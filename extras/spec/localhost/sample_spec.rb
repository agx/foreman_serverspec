require 'spec_helper'

describe command("lsb_release -d") do
  its(:stdout) { should match 'stretch' }
end

describe command("lsb_release -d") do
  its(:stdout) { should_not match 'wheezy' }
end

describe package("foobar") do
  it { should be_installed }
end

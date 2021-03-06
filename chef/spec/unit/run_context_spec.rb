#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Tim Hinderliter (<tim@opscode.com>)
# Author:: Christopher Walters (<cw@opscode.com>)
# Copyright:: Copyright (c) 2008, 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

Chef::Log.level = :debug

describe Chef::RunContext do
  before(:each) do
    Chef::Config.node_path(File.expand_path(File.join(CHEF_SPEC_DATA, "run_context", "nodes")))
    Chef::Config.cookbook_path(File.expand_path(File.join(CHEF_SPEC_DATA, "run_context", "cookbooks")))
    @cookbook_collection = Chef::CookbookCollection.new(Chef::CookbookLoader.new)
    @node = Chef::Node.new
    @node.find_file("run_context")
    @run_context = Chef::RunContext.new(@node, @cookbook_collection)
  end
  
  it "should load all the definitions in the cookbooks for this node" do
    @run_context.definitions.should have_key(:new_cat)
    @run_context.definitions.should have_key(:new_badger)
    @run_context.definitions.should have_key(:new_dog)
  end
  
  it "should load all the recipes specified for this node" do
    @run_context.resource_collection[0].to_s.should == "cat[einstein]"  
    @run_context.resource_collection[1].to_s.should == "cat[loulou]"
    @run_context.resource_collection[2].to_s.should == "cat[birthday]"
    @run_context.resource_collection[3].to_s.should == "cat[peanut]"
    @run_context.resource_collection[4].to_s.should == "cat[fat peanut]"
  end
end

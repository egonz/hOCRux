#!/usr/bin/env ruby
#
# Daemon script that runs to prune the Cyberarts tables
#
require 'rubygems'
require 'daemons'

base_dir = File.expand_path(File.dirname(__FILE__) + '/..')
script = base_dir + '/bin/a_wizard_did_it.rb'
Daemons.run(script,
           :dir_mode => :normal,
           :dir => base_dir + '/log',
           :multiple => true,
           :backtrace => true,
           :monitor => false,
           :log_output => true)

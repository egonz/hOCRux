#!/usr/bin/env ruby
#
# Daemon script that runs
#
require 'rubygems'
require 'daemons'

base_dir = File.expand_path(File.dirname(__FILE__) + '/..')
script = base_dir + '/bin/book_2_pdf.rb'
Daemons.run(script,
           :dir_mode => :normal,
           :dir => base_dir + '/log',
           :multiple => true,
           :backtrace => true,
           :monitor => false,
           :log_output => true)

# Encoding: UTF-8

require_relative '../spec_helper'

describe 'chef-dk::global_shell_init::environment' do
  shared_examples_for 'file with chef shell-init' do
    it 'contains the chef shell-init command' do
      expect(subject.content).to match(/^eval "\$\(chef shell-init bash\)"$/)
    end
  end

  describe file('/etc/bashrc'),
           if: %w(darwin redhat fedora).include?(os[:family]) do
    it_behaves_like 'file with chef shell-init'
  end

  describe file('/etc/bash.bashrc'),
           if: %w(ubuntu debian).include?(os[:family]) do
    it_behaves_like 'file with chef shell-init'
  end
end

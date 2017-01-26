#
# Copyright 2015-2017, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe PoiseApplicationPython::Resources::FlowerConfig do
  step_into(:application_flower_config)
  before do
    allow(File).to receive(:directory?).and_call_original
    allow(File).to receive(:directory?).with('/test').and_return(true)
  end

  context 'with defaults' do
    recipe do
      application_flower_config '/test'
    end
    it { is_expected.to deploy_application_flower_config('/test').with(path: '/test/flowerconfig.py') }
    it { is_expected.to render_file('/test/flowerconfig.py').with_content(eq(<<-FLOWERCONFIG)) }
# Generated by Chef for application_celery_config[/test]

FLOWERCONFIG
  end # /context with defaults

  context 'with a specific path' do
    recipe do
      application_flower_config '/test/foo.py'
    end
    it { is_expected.to deploy_application_flower_config('/test/foo.py').with(path: '/test/foo.py') }
  end # /context with a specific path

  context 'with template options' do
    recipe do
      application_flower_config '/test' do
        options do
          broker 'amqp://'
        end
      end
    end
    it { is_expected.to render_file('/test/flowerconfig.py').with_content(eq(<<-FLOWERCONFIG)) }
# Generated by Chef for application_flower_config[/test]

broker = "amqp://"
FLOWERCONFIG
  end # /context with template options
end

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute("project_id", default: ENV["TF_VAR_project"])

# Ensure first index is type 'Task'
describe command("gcloud --project='#{project_id}' datastore indexes list --filter='properties[0].name=done' --format=json --quiet | jq -jce '.[0].kind'") do
  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should eq 'Task' }
end

# Ensure first index has expected properties
describe command("gcloud --project='#{project_id}' datastore indexes list --filter='properties[0].name=done' --format=json --quiet | jq -jce '.[0].properties'") do
  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should eq '[{"direction":"ASCENDING","name":"done"},{"direction":"DESCENDING","name":"priority"}]' }
end

# Ensure second index is type 'Task'
describe command("gcloud --project='#{project_id}' datastore indexes list --filter='properties[0].name=collaborators' --format=json --quiet | jq -jce '.[0].kind'") do
  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should eq 'Task' }
end

# Ensure second index has expected properties
describe command("gcloud --project='#{project_id}' datastore indexes list --filter='properties[0].name=collaborators' --format=json --quiet | jq -jce '.[0].properties'") do
  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should eq '[{"direction":"ASCENDING","name":"collaborators"},{"direction":"DESCENDING","name":"created"}]' }
end

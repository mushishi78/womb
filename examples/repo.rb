require 'git'
require 'womb'

Repo = Womb[Class.new]
  .assign(:open) { |path| new(Git.open(path)) }
  .assign(:init) { |path| new(Git.init(path)) }
  .assign(:clone) { |url, path| new(Git.clone(url, path)) }
  .init(:git)
  .def(:checkout) { |branch| git.checkout(branch); self }
  .def(:branch) { |branch| git.branch(branch).checkout; self }
  .def(:add) { git.add(all: true); self }
  .def(:commit) { |message| git.commit(message); self }
  .def(:push) { git.push('origin', git.current_branch, force: true); self }
  .def(:ls) { add; git.ls_files.keys }
  .private
  .attr_reader(:git)
  .birth

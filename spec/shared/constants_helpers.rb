module ConstantsHelpers

  extend self

  # helper to remove constants after test-runs.
  def undef_constant(mod, constant_name)
    mod.send(:remove_const, constant_name)
  end
end

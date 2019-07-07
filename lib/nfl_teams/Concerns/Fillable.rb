module Concerns::Fillable
  def create_and_fill(team)
    self.load_all(team)
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe "disponibilidades agrupadas por horario" do
	before(:each) do
  	Disponibilidade.create(:professor_id => 1, :horario_id => 108)
		Disponibilidade.create(:professor_id => 2, :horario_id => 108, :disciplina_id => 1)
    Disponibilidade.create(:professor_id => 1, :horario_id => 614, :disciplina_id => 1)
	end

	it "todas" do
		Disponibilidade.count.should == 3
	end

	it "reservadas" do
		Disponibilidade.reservadas.count.should == 2
	end

	it "livres" do
		Disponibilidade.livres.count.should == 1
	end
end
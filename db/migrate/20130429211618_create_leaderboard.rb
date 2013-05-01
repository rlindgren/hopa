class CreateLeaders < ActiveRecord::Migration
  def up
  	create_table 'leaders' do |t|
  		t.string 'name'
  		t.string 'score'
  		t.datetime 'played_on'
  		t.timestamps
  	end
  end

  def down
  	drop_table 'leaders'
  end
end

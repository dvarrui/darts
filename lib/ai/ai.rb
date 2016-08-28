# encoding: utf-8

require_relative 'stages/stage_d'
require_relative 'stages/stage_b'
require_relative 'stages/stage_f'
require_relative 'stages/stage_i'
require_relative 'stages/stage_s'
require_relative 'stages/stage_t'

require_relative 'ai_calculate'

module AI
  include AI_calculate

  def make_questions_from_ai
    return if @process==false

    #---------------------------------------------------------
    #Stage D: process every definition, I mean every <def> tag
    @questions[:d] = StageD.new(self).run
    @questions[:i] = StageI.new(self).run
    @questions[:b] = []
    @questions[:f] = []
    @questions[:s] = []
    @questions[:t] = []

    #-----------------------------------
    #Process every table of this concept
    tables.each do |lTable|

      list1, list2 = get_list1_and_list2_from(lTable)
      list3=list1+list2

      #----------------------------------------------
      #Stage B: process table to make match questions
      @questions[:b] += StageB.new(self).run(lTable, list1, list2)
      #-----------------------------
      #Stage T: process_tableXfields
      list1.each do |lRow|
        reorder_list_with_row(list3, lRow)
        @questions[:t] += StageT.new(self).run(lTable, lRow, list3)
      end

      #--------------------------------------
      #Stage S: process tables with sequences
      @questions[:s] += StageS.new(self).run(lTable, list1, list2)
      #-----------------------------------------
      #Stage F: process tables with only 1 field
      @questions[:f] += StageF.new(self).run(lTable, list1, list2)
    end
  end

  def get_list1_and_list2_from(lTable)
    #create <list1> with all the rows from the table
    list1=[]
    count=1
    lTable.rows.each do |i|
      list1 << { :id => count, :name => name, :weight => 0, :data => i }
      count+=1
    end

    #create a <list2> with similar rows (same table name) from the neighbours tables
    list2=[]
    neighbors.each do |n|
      n[:concept].tables.each do |t2|
        if t2.name==lTable.name then
          t2.rows.each do |i|
            list2 << { :id => count, :name => n[:concept].name, :weight => 0, :data => i }
            count+=1
          end
        end
      end
    end
    return list1, list2
  end

end

#encoding: utf-8
class Basket < ActiveRecord::Base
  belongs_to :framework
  belongs_to :onwer, :foreign_key => "onwer_id", :class_name => "User"
  has_many :mice, :foreign_key =>"basket_id", :class_name => "Mouse"
  BASKETTYPE = {"Mating" => "M", "Stock" => "S","Breeding" => "B","Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
  def basket_type_label
    Basket::BASKETTYPE.invert[self.cage_type]
  end
  def count_mice_in_basket 
     "#{self.code}[#{self.basket_type_label}][#{self.mice.size}]只"
  end
  def is_correct_cage_type
    mice = self.mice.alive_mice
    if self.cage_type == "S"
      if (mice.male_mice.size > 0 and mice.female_mice.size > 0 ) or mice.litter_mice.size > 0
        false
      else
        true
      end
    elsif self.cage_type == "M"
      if mice.male_mice.size > 1
        false
      else
        true
      end
    elsif self.cage_type == "B"
      if mice.female_mice.size > 1 or mice.male_mice.size > 0 or (mice.female_mice.size == 1 and mice.female_mice.first.f_breeds.size < 0)
        false
      else
        true
      end
    elsif self.cage_type == "CE"
      true
    elsif self.cage_type == "NE"
      true
    end
  end
  def get_basket_types
    if self.mice.size == 0
      bask_types = {"Mating" => "M", "Stock" => "S","Breeding" => "B","Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
    else
      if self.mice.male_mice.size > 1 and self.mice.female_mice.size == 0
        bask_types = {"Stock" => "S","Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
      elsif self.mice.male_mice.size == 1 and self.mice.female_mice.size == 0 
        bask_types = {"Mating" => "M","Stock" => "S","Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
      elsif self.mice.female_mice.size > 0 and self.mice.male_mice.size < 1
        bask_types = {"Mating" => "M", "Stock" => "S","Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
      elsif self.mice.female_mice.size > 0 and self.mice.male_mice.size == 1
        bask_types = {"Mating" => "M", "Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
      else
        bask_types = {"Contagious Experiment" => "CE","Non-Contagious Experiment" => "NCE"}
      end
    end
    
  end
end

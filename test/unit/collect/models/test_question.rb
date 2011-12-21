require 'helper'

class TestQuestion < Test::Unit::TestCase
  def new_question(attribs = {})
    Collect::Question.new({
      :name => 'foo',
      :prompt => 'Foo:',
      :type => 'Integer',
      :section => @section
    }.merge(attribs))
  end

  def setup
    super
    @project = Collect::Project.create(:name => 'foo', :database_adapter => 'sqlite')
    @form = Collect::Form.create(:name => 'foo', :project => @project)
    @section = Collect::Section.create(:name => 'foo', :form => @form)
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::Question.superclass
  end

  test "many_to_one section" do
    assert_respond_to Collect::Question.new, :section
  end

  test "requires name" do
    question = new_question(:name => nil)
    assert !question.valid?
  end

  test "requires valid name" do
    question = new_question(:name => 'foo bar')
    assert !question.valid?
  end

  test "requires section_id" do
    question = new_question(:section => nil)
    assert !question.valid?
  end

  test "requires unique name over form" do
    section_1 = Collect::Section.create(:name => 'section 1', :form => @form)
    question_1 = new_question(:name => 'foo', :section => section_1)
    assert question_1.save

    section_2 = Collect::Section.create(:name => 'section 2', :form => @form)
    question_2 = new_question(:name => 'foo', :section => section_2)
    assert !question_2.valid?

    question_2.name = 'foo_bar'
    assert question_2.save
    assert question_2.valid?

    question_2.name = 'foo'
    assert !question_2.valid?
  end

  test "requires prompt" do
    question = new_question(:prompt => nil)
    assert !question.valid?
  end

  test "requires type" do
    question = new_question(:type => nil)
    assert !question.valid?
  end

  test "requires valid type" do
    question = new_question(:type => 'junk')
    assert !question.valid?
  end
end

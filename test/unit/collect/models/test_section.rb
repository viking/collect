require 'helper'

class TestSection < CollectUnitTest
  def new_section(attribs = {})
    Collect::Section.new({
      :name => 'foo',
      :form => @form
    }.merge(attribs))
  end

  def setup
    super
    @project = Collect::Project.create!(:name => 'foo', :database_adapter => 'sqlite')
    @form = Collect::Form.create!(:name => 'foo', :project => @project)
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::Section.superclass
  end

  test "requires name" do
    section = new_section(:name => nil)
    assert !section.valid?
  end

  test "many_to_one form" do
    section = new_section
    assert_respond_to section, :form
  end

  test "requires form_id" do
    section = new_section(:form => nil)
    assert !section.valid?
  end

  test "one_to_many question" do
    section = new_section
    assert_respond_to section, :questions
  end

  test "accepts nested attributes for questions" do
    section = new_section({:questions_attributes => [
      {:name => 'foo', :prompt => 'foo?', :type => 'string'}
    ]})
    assert_equal 1, section.questions.length
  end
end

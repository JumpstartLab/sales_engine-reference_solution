describe SalesEngine do
  describe '.startup' do
    before do
      SalesEngine.startup('spec/support/data')
    end

    it 'populates the instances for all of the models' do
      SalesEngine::Models.classes.each do |model_class|
        model_class.should have(10).instances
        model_class.instances.should all_be_an_instance_of(model_class)
      end
    end
  end
end
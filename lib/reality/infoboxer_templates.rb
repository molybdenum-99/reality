Infoboxer::MediaWiki::Traits.for('en.wikipedia.org') do
  templates do
    template 'lang' do
      def children
        fetch('2')
      end
    end

    show 'US$' # TODO: in fact, has second option (year)
  end
end

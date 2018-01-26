# frozen_string_literal: true

require_relative './actions/base'

module Reality::Describers::Wikidata::Impl
  # Methods of this module contains all actions that can be used on {Api}.
  # You use them like this:
  #
  # ```ruby
  # api = Reality::Describers::Wikidata::Impl::Api.new
  #
  # api.query                           # method of Api, returning Actions::Query
  #    .titles('Argentina', 'Bolivia')  # methods of Actions::Query...
  #    .prop(:revisions).prop(:content) # ...to set action options
  #    .response
  # # => performs action and returns Response instance
  # ```
  #
  # See also:
  # * {Api} for starting;
  # * {Actions::Base} for details of working with actions;
  # * and {Response}.
  #
  # Note that for each MediaWiki site the main method for **data extraction** (pages, categories,
  # meta-information) is {#query}.
  #
  module Actions

    # Check to see if an AbuseFilter matches a set of variables, editor logged AbuseFilter event.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Abusefiltercheckmatch} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefiltercheckmatch} method calls, like
    #
    # ```ruby
    # api.abusefiltercheckmatch.filter('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefiltercheckmatch} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Abusefiltercheckmatch]
    #
    def abusefiltercheckmatch
      Abusefiltercheckmatch.new(client, @defaults)
    end

    # Check syntax of an AbuseFilter filter.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Abusefilterchecksyntax} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefilterchecksyntax} method calls, like
    #
    # ```ruby
    # api.abusefilterchecksyntax.filter('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefilterchecksyntax} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Abusefilterchecksyntax]
    #
    def abusefilterchecksyntax
      Abusefilterchecksyntax.new(client, @defaults)
    end

    # Evaluates an AbuseFilter expression.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Abusefilterevalexpression} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefilterevalexpression} method calls, like
    #
    # ```ruby
    # api.abusefilterevalexpression.expression('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefilterevalexpression} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Abusefilterevalexpression]
    #
    def abusefilterevalexpression
      Abusefilterevalexpression.new(client, @defaults)
    end

    # Unblocks a user from receiving autopromotions due to an abusefilter consequence.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Abusefilterunblockautopromote} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefilterunblockautopromote} method calls, like
    #
    # ```ruby
    # api.abusefilterunblockautopromote.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Abusefilterunblockautopromote} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Abusefilterunblockautopromote]
    #
    def abusefilterunblockautopromote
      Abusefilterunblockautopromote.new(client, @defaults)
    end

    # Manage aggregate message groups.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Aggregategroups} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Aggregategroups} method calls, like
    #
    # ```ruby
    # api.aggregategroups.do('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Aggregategroups} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Aggregategroups]
    #
    def aggregategroups
      Aggregategroups.new(client, @defaults)
    end

    # Check a username against AntiSpoof's normalisation checks.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Antispoof} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Antispoof} method calls, like
    #
    # ```ruby
    # api.antispoof.username('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Antispoof} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Antispoof]
    #
    def antispoof
      Antispoof.new(client, @defaults)
    end

    # Block a user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Block} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Block} method calls, like
    #
    # ```ruby
    # api.block.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Block} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Block]
    #
    def block
      Block.new(client, @defaults)
    end

    # Receive a bounce email and process it to handle the failing recipient.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Bouncehandler} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Bouncehandler} method calls, like
    #
    # ```ruby
    # api.bouncehandler.email('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Bouncehandler} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Bouncehandler]
    #
    def bouncehandler
      Bouncehandler.new(client, @defaults)
    end

    # Internal module for the CategoryTree extension.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Categorytree} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Categorytree} method calls, like
    #
    # ```ruby
    # api.categorytree.category('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Categorytree} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Categorytree]
    #
    def categorytree
      Categorytree.new(client, @defaults)
    end

    # Fetch a centralauthtoken for making an authenticated request to an attached wiki.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Centralauthtoken} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Centralauthtoken} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Centralauthtoken]
    #
    def centralauthtoken
      Centralauthtoken.new(client, @defaults)
    end

    # Get data needed to choose a banner for a given project and language
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Centralnoticechoicedata} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Centralnoticechoicedata} method calls, like
    #
    # ```ruby
    # api.centralnoticechoicedata.project('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Centralnoticechoicedata} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Centralnoticechoicedata]
    #
    def centralnoticechoicedata
      Centralnoticechoicedata.new(client, @defaults)
    end

    # Get all configuration settings for a campaign.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Centralnoticequerycampaign} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Centralnoticequerycampaign} method calls, like
    #
    # ```ruby
    # api.centralnoticequerycampaign.campaign('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Centralnoticequerycampaign} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Centralnoticequerycampaign]
    #
    def centralnoticequerycampaign
      Centralnoticequerycampaign.new(client, @defaults)
    end

    # Change authentication data for the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Changeauthenticationdata} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Changeauthenticationdata} method calls, like
    #
    # ```ruby
    # api.changeauthenticationdata.request('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Changeauthenticationdata} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Changeauthenticationdata]
    #
    def changeauthenticationdata
      Changeauthenticationdata.new(client, @defaults)
    end

    # Check the validity of a token from action=query&meta=tokens.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Checktoken} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Checktoken} method calls, like
    #
    # ```ruby
    # api.checktoken.type('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Checktoken} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Checktoken]
    #
    def checktoken
      Checktoken.new(client, @defaults)
    end

    # Dump of CirrusSearch configuration.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::CirrusConfigDump} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::CirrusConfigDump} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::CirrusConfigDump]
    #
    def cirrus_config_dump
      CirrusConfigDump.new(client, @defaults)
    end

    # Dump of CirrusSearch mapping for this wiki.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::CirrusMappingDump} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::CirrusMappingDump} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::CirrusMappingDump]
    #
    def cirrus_mapping_dump
      CirrusMappingDump.new(client, @defaults)
    end

    # Dump of CirrusSearch settings for this wiki.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::CirrusSettingsDump} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::CirrusSettingsDump} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::CirrusSettingsDump]
    #
    def cirrus_settings_dump
      CirrusSettingsDump.new(client, @defaults)
    end

    # Clears the hasmsg flag for the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Clearhasmsg} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Clearhasmsg} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Clearhasmsg]
    #
    def clearhasmsg
      Clearhasmsg.new(client, @defaults)
    end

    # Log in to the wiki using the interactive flow.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Clientlogin} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Clientlogin} method calls, like
    #
    # ```ruby
    # api.clientlogin.requests('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Clientlogin} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Clientlogin]
    #
    def clientlogin
      Clientlogin.new(client, @defaults)
    end

    # Get the difference between 2 pages.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Compare} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Compare} method calls, like
    #
    # ```ruby
    # api.compare.fromtitle('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Compare} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Compare]
    #
    def compare
      Compare.new(client, @defaults)
    end

    # Create a new user account.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Createaccount} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Createaccount} method calls, like
    #
    # ```ruby
    # api.createaccount.requests('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Createaccount} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Createaccount]
    #
    def createaccount
      Createaccount.new(client, @defaults)
    end

    # Used by browsers to report violations of the Content Security Policy. This module should never be used, except when used automatically by a CSP compliant web browser.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Cspreport} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Cspreport} method calls, like
    #
    # ```ruby
    # api.cspreport.reportonly('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Cspreport} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Cspreport]
    #
    def cspreport
      Cspreport.new(client, @defaults)
    end

    # Delete a page.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Delete} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Delete} method calls, like
    #
    # ```ruby
    # api.delete.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Delete} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Delete]
    #
    def delete
      Delete.new(client, @defaults)
    end

    # Delete a global user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Deleteglobalaccount} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Deleteglobalaccount} method calls, like
    #
    # ```ruby
    # api.deleteglobalaccount.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Deleteglobalaccount} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Deleteglobalaccount]
    #
    def deleteglobalaccount
      Deleteglobalaccount.new(client, @defaults)
    end

    # Mark notifications as read for the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Echomarkread} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Echomarkread} method calls, like
    #
    # ```ruby
    # api.echomarkread.list('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Echomarkread} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Echomarkread]
    #
    def echomarkread
      Echomarkread.new(client, @defaults)
    end

    # Mark notifications as seen for the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Echomarkseen} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Echomarkseen} method calls, like
    #
    # ```ruby
    # api.echomarkseen.token('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Echomarkseen} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Echomarkseen]
    #
    def echomarkseen
      Echomarkseen.new(client, @defaults)
    end

    # Create and edit pages.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Edit} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Edit} method calls, like
    #
    # ```ruby
    # api.edit.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Edit} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Edit]
    #
    def edit
      Edit.new(client, @defaults)
    end

    # Edit a mass message delivery list.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Editmassmessagelist} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Editmassmessagelist} method calls, like
    #
    # ```ruby
    # api.editmassmessagelist.spamlist('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Editmassmessagelist} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Editmassmessagelist]
    #
    def editmassmessagelist
      Editmassmessagelist.new(client, @defaults)
    end

    # Email a user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Emailuser} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Emailuser} method calls, like
    #
    # ```ruby
    # api.emailuser.target('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Emailuser} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Emailuser]
    #
    def emailuser
      Emailuser.new(client, @defaults)
    end

    # Expands all templates within wikitext.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Expandtemplates} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Expandtemplates} method calls, like
    #
    # ```ruby
    # api.expandtemplates.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Expandtemplates} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Expandtemplates]
    #
    def expandtemplates
      Expandtemplates.new(client, @defaults)
    end

    # Get a new FancyCaptcha.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Fancycaptchareload} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Fancycaptchareload} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Fancycaptchareload]
    #
    def fancycaptchareload
      Fancycaptchareload.new(client, @defaults)
    end

    # Returns a featured content feed.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Featuredfeed} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Featuredfeed} method calls, like
    #
    # ```ruby
    # api.featuredfeed.feedformat('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Featuredfeed} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Featuredfeed]
    #
    def featuredfeed
      Featuredfeed.new(client, @defaults)
    end

    # Returns a user contributions feed.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Feedcontributions} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Feedcontributions} method calls, like
    #
    # ```ruby
    # api.feedcontributions.feedformat('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Feedcontributions} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Feedcontributions]
    #
    def feedcontributions
      Feedcontributions.new(client, @defaults)
    end

    # Returns a recent changes feed.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Feedrecentchanges} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Feedrecentchanges} method calls, like
    #
    # ```ruby
    # api.feedrecentchanges.feedformat('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Feedrecentchanges} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Feedrecentchanges]
    #
    def feedrecentchanges
      Feedrecentchanges.new(client, @defaults)
    end

    # Returns a watchlist feed.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Feedwatchlist} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Feedwatchlist} method calls, like
    #
    # ```ruby
    # api.feedwatchlist.feedformat('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Feedwatchlist} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Feedwatchlist]
    #
    def feedwatchlist
      Feedwatchlist.new(client, @defaults)
    end

    # Revert a file to an old version.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Filerevert} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Filerevert} method calls, like
    #
    # ```ruby
    # api.filerevert.filename('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Filerevert} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Filerevert]
    #
    def filerevert
      Filerevert.new(client, @defaults)
    end

    # Allows actions to be taken on Flow pages.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Flow} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Flow} method calls, like
    #
    # ```ruby
    # api.flow.submodule('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Flow} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Flow]
    #
    def flow
      Flow.new(client, @defaults)
    end

    # Convert text between wikitext and HTML.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::FlowParsoidUtils} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::FlowParsoidUtils} method calls, like
    #
    # ```ruby
    # api.flow_parsoid_utils.from('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::FlowParsoidUtils} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::FlowParsoidUtils]
    #
    def flow_parsoid_utils
      FlowParsoidUtils.new(client, @defaults)
    end

    # Send a public thank-you notification for a Flow comment.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Flowthank} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Flowthank} method calls, like
    #
    # ```ruby
    # api.flowthank.postid('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Flowthank} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Flowthank]
    #
    def flowthank
      Flowthank.new(client, @defaults)
    end

    # Globally block or unblock a user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Globalblock} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Globalblock} method calls, like
    #
    # ```ruby
    # api.globalblock.target('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Globalblock} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Globalblock]
    #
    def globalblock
      Globalblock.new(client, @defaults)
    end

    # Add/remove a user to/from global groups.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Globaluserrights} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Globaluserrights} method calls, like
    #
    # ```ruby
    # api.globaluserrights.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Globaluserrights} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Globaluserrights]
    #
    def globaluserrights
      Globaluserrights.new(client, @defaults)
    end

    # Access graph tag functionality.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Graph} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Graph} method calls, like
    #
    # ```ruby
    # api.graph.hash('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Graph} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Graph]
    #
    def graph
      Graph.new(client, @defaults)
    end

    # Set message group workflow states.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Groupreview} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Groupreview} method calls, like
    #
    # ```ruby
    # api.groupreview.group('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Groupreview} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Groupreview]
    #
    def groupreview
      Groupreview.new(client, @defaults)
    end

    # Display help for the specified modules.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Help} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Help} method calls, like
    #
    # ```ruby
    # api.help.modules('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Help} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Help]
    #
    def help
      Help.new(client, @defaults)
    end

    # This module has been disabled.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Imagerotate} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Imagerotate} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Imagerotate]
    #
    def imagerotate
      Imagerotate.new(client, @defaults)
    end

    # Import a page from another wiki, or from an XML file.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Import} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Import} method calls, like
    #
    # ```ruby
    # api.import.summary('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Import} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Import]
    #
    def import
      Import.new(client, @defaults)
    end

    # Allows direct access to JsonConfig subsystem.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Jsonconfig} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Jsonconfig} method calls, like
    #
    # ```ruby
    # api.jsonconfig.command('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Jsonconfig} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Jsonconfig]
    #
    def jsonconfig
      Jsonconfig.new(client, @defaults)
    end

    # Retrieve localized JSON data.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Jsondata} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Jsondata} method calls, like
    #
    # ```ruby
    # api.jsondata.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Jsondata} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Jsondata]
    #
    def jsondata
      Jsondata.new(client, @defaults)
    end

    # Search for language names in any script.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Languagesearch} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Languagesearch} method calls, like
    #
    # ```ruby
    # api.languagesearch.search('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Languagesearch} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Languagesearch]
    #
    def languagesearch
      Languagesearch.new(client, @defaults)
    end

    # Link an account from a third-party provider to the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Linkaccount} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Linkaccount} method calls, like
    #
    # ```ruby
    # api.linkaccount.requests('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Linkaccount} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Linkaccount]
    #
    def linkaccount
      Linkaccount.new(client, @defaults)
    end

    # Log in and get authentication cookies.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Login} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Login} method calls, like
    #
    # ```ruby
    # api.login.name('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Login} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Login]
    #
    def login
      Login.new(client, @defaults)
    end

    # Log out and clear session data.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Logout} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Logout} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Logout]
    #
    def logout
      Logout.new(client, @defaults)
    end

    # Perform management tasks relating to change tags.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Managetags} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Managetags} method calls, like
    #
    # ```ruby
    # api.managetags.operation('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Managetags} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Managetags]
    #
    def managetags
      Managetags.new(client, @defaults)
    end

    # Send a message to a list of pages.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Massmessage} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Massmessage} method calls, like
    #
    # ```ruby
    # api.massmessage.spamlist('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Massmessage} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Massmessage]
    #
    def massmessage
      Massmessage.new(client, @defaults)
    end

    # Merge page histories.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Mergehistory} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Mergehistory} method calls, like
    #
    # ```ruby
    # api.mergehistory.from('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Mergehistory} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Mergehistory]
    #
    def mergehistory
      Mergehistory.new(client, @defaults)
    end

    # Returns data needed for mobile views.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Mobileview} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Mobileview} method calls, like
    #
    # ```ruby
    # api.mobileview.page('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Mobileview} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Mobileview]
    #
    def mobileview
      Mobileview.new(client, @defaults)
    end

    # Move a page.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Move} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Move} method calls, like
    #
    # ```ruby
    # api.move.from('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Move} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Move]
    #
    def move
      Move.new(client, @defaults)
    end

    # Validate a two-factor authentication (OATH) token.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Oathvalidate} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Oathvalidate} method calls, like
    #
    # ```ruby
    # api.oathvalidate.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Oathvalidate} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Oathvalidate]
    #
    def oathvalidate
      Oathvalidate.new(client, @defaults)
    end

    # Search the wiki using the OpenSearch protocol.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Opensearch} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Opensearch} method calls, like
    #
    # ```ruby
    # api.opensearch.search('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Opensearch} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Opensearch]
    #
    def opensearch
      Opensearch.new(client, @defaults)
    end

    # Change preferences of the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Options} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Options} method calls, like
    #
    # ```ruby
    # api.options.reset('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Options} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Options]
    #
    def options
      Options.new(client, @defaults)
    end

    # Obtain information about API modules.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Paraminfo} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Paraminfo} method calls, like
    #
    # ```ruby
    # api.paraminfo.modules('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Paraminfo} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Paraminfo]
    #
    def paraminfo
      Paraminfo.new(client, @defaults)
    end

    # Parses content and returns parser output.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Parse} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Parse} method calls, like
    #
    # ```ruby
    # api.parse.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Parse} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Parse]
    #
    def parse
      Parse.new(client, @defaults)
    end

    # 
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::ParsoidBatch} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::ParsoidBatch} method calls, like
    #
    # ```ruby
    # api.parsoid_batch.batch('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::ParsoidBatch} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::ParsoidBatch]
    #
    def parsoid_batch
      ParsoidBatch.new(client, @defaults)
    end

    # Patrol a page or revision.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Patrol} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Patrol} method calls, like
    #
    # ```ruby
    # api.patrol.rcid('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Patrol} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Patrol]
    #
    def patrol
      Patrol.new(client, @defaults)
    end

    # Change the protection level of a page.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Protect} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Protect} method calls, like
    #
    # ```ruby
    # api.protect.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Protect} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Protect]
    #
    def protect
      Protect.new(client, @defaults)
    end

    # Purge the cache for the given titles.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Purge} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Purge} method calls, like
    #
    # ```ruby
    # api.purge.forcelinkupdate('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Purge} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Purge]
    #
    def purge
      Purge.new(client, @defaults)
    end

    # Fetch data from and about MediaWiki.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Query} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Query} method calls, like
    #
    # ```ruby
    # api.query.prop('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Query} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Query]
    #
    def query
      Query.new(client, @defaults)
    end

    # Remove authentication data for the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Removeauthenticationdata} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Removeauthenticationdata} method calls, like
    #
    # ```ruby
    # api.removeauthenticationdata.request('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Removeauthenticationdata} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Removeauthenticationdata]
    #
    def removeauthenticationdata
      Removeauthenticationdata.new(client, @defaults)
    end

    # Send a password reset email to a user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Resetpassword} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Resetpassword} method calls, like
    #
    # ```ruby
    # api.resetpassword.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Resetpassword} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Resetpassword]
    #
    def resetpassword
      Resetpassword.new(client, @defaults)
    end

    # Delete and undelete revisions.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Revisiondelete} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Revisiondelete} method calls, like
    #
    # ```ruby
    # api.revisiondelete.type('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Revisiondelete} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Revisiondelete]
    #
    def revisiondelete
      Revisiondelete.new(client, @defaults)
    end

    # Undo the last edit to the page.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Rollback} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Rollback} method calls, like
    #
    # ```ruby
    # api.rollback.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Rollback} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Rollback]
    #
    def rollback
      Rollback.new(client, @defaults)
    end

    # Export an RSD (Really Simple Discovery) schema.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Rsd} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Rsd} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Rsd]
    #
    def rsd
      Rsd.new(client, @defaults)
    end

    # Performs data validation for Kartographer extension
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::SanitizeMapdata} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::SanitizeMapdata} method calls, like
    #
    # ```ruby
    # api.sanitize_mapdata.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::SanitizeMapdata} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::SanitizeMapdata]
    #
    def sanitize_mapdata
      SanitizeMapdata.new(client, @defaults)
    end

    # Internal module for servicing XHR requests from the Scribunto console.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::ScribuntoConsole} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::ScribuntoConsole} method calls, like
    #
    # ```ruby
    # api.scribunto_console.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::ScribuntoConsole} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::ScribuntoConsole]
    #
    def scribunto_console
      ScribuntoConsole.new(client, @defaults)
    end

    # Search translations.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Searchtranslations} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Searchtranslations} method calls, like
    #
    # ```ruby
    # api.searchtranslations.service('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Searchtranslations} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Searchtranslations]
    #
    def searchtranslations
      Searchtranslations.new(client, @defaults)
    end

    # Set a global user's status.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Setglobalaccountstatus} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Setglobalaccountstatus} method calls, like
    #
    # ```ruby
    # api.setglobalaccountstatus.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Setglobalaccountstatus} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Setglobalaccountstatus]
    #
    def setglobalaccountstatus
      Setglobalaccountstatus.new(client, @defaults)
    end

    # Update the notification timestamp for watched pages.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Setnotificationtimestamp} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Setnotificationtimestamp} method calls, like
    #
    # ```ruby
    # api.setnotificationtimestamp.entirewatchlist('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Setnotificationtimestamp} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Setnotificationtimestamp]
    #
    def setnotificationtimestamp
      Setnotificationtimestamp.new(client, @defaults)
    end

    # Change the language of a page.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Setpagelanguage} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Setpagelanguage} method calls, like
    #
    # ```ruby
    # api.setpagelanguage.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Setpagelanguage} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Setpagelanguage]
    #
    def setpagelanguage
      Setpagelanguage.new(client, @defaults)
    end

    # Shorten a long URL into a shorter one.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Shortenurl} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Shortenurl} method calls, like
    #
    # ```ruby
    # api.shortenurl.url('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Shortenurl} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Shortenurl]
    #
    def shortenurl
      Shortenurl.new(client, @defaults)
    end

    # Get Wikimedia sites list.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Sitematrix} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Sitematrix} method calls, like
    #
    # ```ruby
    # api.sitematrix.type('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Sitematrix} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Sitematrix]
    #
    def sitematrix
      Sitematrix.new(client, @defaults)
    end

    # Validate one or more URLs against the SpamBlacklist.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Spamblacklist} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Spamblacklist} method calls, like
    #
    # ```ruby
    # api.spamblacklist.url('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Spamblacklist} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Spamblacklist]
    #
    def spamblacklist
      Spamblacklist.new(client, @defaults)
    end

    # Prepare an edit in shared cache.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Stashedit} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Stashedit} method calls, like
    #
    # ```ruby
    # api.stashedit.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Stashedit} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Stashedit]
    #
    def stashedit
      Stashedit.new(client, @defaults)
    end

    # Allows admins to strike or unstrike a vote.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Strikevote} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Strikevote} method calls, like
    #
    # ```ruby
    # api.strikevote.option('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Strikevote} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Strikevote]
    #
    def strikevote
      Strikevote.new(client, @defaults)
    end

    # Add or remove change tags from individual revisions or log entries.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Tag} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Tag} method calls, like
    #
    # ```ruby
    # api.tag.rcid('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Tag} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Tag]
    #
    def tag
      Tag.new(client, @defaults)
    end

    # Fetch data stored by the TemplateData extension.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Templatedata} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Templatedata} method calls, like
    #
    # ```ruby
    # api.templatedata.titles('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Templatedata} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Templatedata]
    #
    def templatedata
      Templatedata.new(client, @defaults)
    end

    # Send a thank-you notification to an editor.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Thank} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Thank} method calls, like
    #
    # ```ruby
    # api.thank.rev('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Thank} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Thank]
    #
    def thank
      Thank.new(client, @defaults)
    end

    # Validate an article title, filename, or username against the TitleBlacklist.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Titleblacklist} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Titleblacklist} method calls, like
    #
    # ```ruby
    # api.titleblacklist.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Titleblacklist} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Titleblacklist]
    #
    def titleblacklist
      Titleblacklist.new(client, @defaults)
    end

    # Get tokens for data-modifying actions.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Tokens} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Tokens} method calls, like
    #
    # ```ruby
    # api.tokens.type('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Tokens} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Tokens]
    #
    def tokens
      Tokens.new(client, @defaults)
    end

    # Users with the 'transcode-reset' right can reset and re-run a transcode job.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Transcodereset} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Transcodereset} method calls, like
    #
    # ```ruby
    # api.transcodereset.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Transcodereset} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Transcodereset]
    #
    def transcodereset
      Transcodereset.new(client, @defaults)
    end

    # Signup and manage sandboxed users.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Translatesandbox} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Translatesandbox} method calls, like
    #
    # ```ruby
    # api.translatesandbox.do('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Translatesandbox} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Translatesandbox]
    #
    def translatesandbox
      Translatesandbox.new(client, @defaults)
    end

    # Query all translations aids.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Translationaids} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Translationaids} method calls, like
    #
    # ```ruby
    # api.translationaids.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Translationaids} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Translationaids]
    #
    def translationaids
      Translationaids.new(client, @defaults)
    end

    # Mark translations reviewed.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Translationreview} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Translationreview} method calls, like
    #
    # ```ruby
    # api.translationreview.revision('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Translationreview} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Translationreview]
    #
    def translationreview
      Translationreview.new(client, @defaults)
    end

    # Add translations to stash.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Translationstash} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Translationstash} method calls, like
    #
    # ```ruby
    # api.translationstash.subaction('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Translationstash} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Translationstash]
    #
    def translationstash
      Translationstash.new(client, @defaults)
    end

    # Query suggestions from translation memories.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Ttmserver} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Ttmserver} method calls, like
    #
    # ```ruby
    # api.ttmserver.service('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Ttmserver} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Ttmserver]
    #
    def ttmserver
      Ttmserver.new(client, @defaults)
    end

    # Get the localization of ULS in the given language.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Ulslocalization} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Ulslocalization} method calls, like
    #
    # ```ruby
    # api.ulslocalization.language('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Ulslocalization} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Ulslocalization]
    #
    def ulslocalization
      Ulslocalization.new(client, @defaults)
    end

    # Unblock a user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Unblock} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Unblock} method calls, like
    #
    # ```ruby
    # api.unblock.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Unblock} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Unblock]
    #
    def unblock
      Unblock.new(client, @defaults)
    end

    # Restore revisions of a deleted page.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Undelete} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Undelete} method calls, like
    #
    # ```ruby
    # api.undelete.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Undelete} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Undelete]
    #
    def undelete
      Undelete.new(client, @defaults)
    end

    # Remove a linked third-party account from the current user.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Unlinkaccount} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Unlinkaccount} method calls, like
    #
    # ```ruby
    # api.unlinkaccount.request('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Unlinkaccount} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Unlinkaccount]
    #
    def unlinkaccount
      Unlinkaccount.new(client, @defaults)
    end

    # Upload a file, or get the status of pending uploads.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Upload} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Upload} method calls, like
    #
    # ```ruby
    # api.upload.filename('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Upload} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Upload]
    #
    def upload
      Upload.new(client, @defaults)
    end

    # Change a user's group membership.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Userrights} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Userrights} method calls, like
    #
    # ```ruby
    # api.userrights.user('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Userrights} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Userrights]
    #
    def userrights
      Userrights.new(client, @defaults)
    end

    # Validate a password against the wiki's password policies.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Validatepassword} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Validatepassword} method calls, like
    #
    # ```ruby
    # api.validatepassword.password('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Validatepassword} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Validatepassword]
    #
    def validatepassword
      Validatepassword.new(client, @defaults)
    end

    # Returns HTML5 for a page from the Parsoid service.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Visualeditor} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Visualeditor} method calls, like
    #
    # ```ruby
    # api.visualeditor.page('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Visualeditor} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Visualeditor]
    #
    def visualeditor
      Visualeditor.new(client, @defaults)
    end

    # Save an HTML5 page to MediaWiki (converted to wikitext via the Parsoid service).
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Visualeditoredit} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Visualeditoredit} method calls, like
    #
    # ```ruby
    # api.visualeditoredit.paction('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Visualeditoredit} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Visualeditoredit]
    #
    def visualeditoredit
      Visualeditoredit.new(client, @defaults)
    end

    # Add or remove pages from the current user's watchlist.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Watch} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Watch} method calls, like
    #
    # ```ruby
    # api.watch.title('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Watch} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Watch]
    #
    def watch
      Watch.new(client, @defaults)
    end

    # Queries available badge items.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbavailablebadges} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbavailablebadges} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbavailablebadges]
    #
    def wbavailablebadges
      Wbavailablebadges.new(client, @defaults)
    end

    # Performs constraint checks on any entity you want and returns the result.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbcheckconstraints} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbcheckconstraints} method calls, like
    #
    # ```ruby
    # api.wbcheckconstraints.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbcheckconstraints} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbcheckconstraints]
    #
    def wbcheckconstraints
      Wbcheckconstraints.new(client, @defaults)
    end

    # Creates Wikibase claims.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbcreateclaim} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbcreateclaim} method calls, like
    #
    # ```ruby
    # api.wbcreateclaim.entity('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbcreateclaim} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbcreateclaim]
    #
    def wbcreateclaim
      Wbcreateclaim.new(client, @defaults)
    end

    # Creates Entity redirects.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbcreateredirect} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbcreateredirect} method calls, like
    #
    # ```ruby
    # api.wbcreateredirect.from('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbcreateredirect} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbcreateredirect]
    #
    def wbcreateredirect
      Wbcreateredirect.new(client, @defaults)
    end

    # Creates a single new Wikibase entity and modifies it with serialised information.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbeditentity} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbeditentity} method calls, like
    #
    # ```ruby
    # api.wbeditentity.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbeditentity} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbeditentity]
    #
    def wbeditentity
      Wbeditentity.new(client, @defaults)
    end

    # Formats DataValues.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbformatvalue} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbformatvalue} method calls, like
    #
    # ```ruby
    # api.wbformatvalue.generate('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbformatvalue} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbformatvalue]
    #
    def wbformatvalue
      Wbformatvalue.new(client, @defaults)
    end

    # Gets Wikibase claims.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbgetclaims} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbgetclaims} method calls, like
    #
    # ```ruby
    # api.wbgetclaims.entity('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbgetclaims} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbgetclaims]
    #
    def wbgetclaims
      Wbgetclaims.new(client, @defaults)
    end

    # Gets the data for multiple Wikibase entities.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbgetentities} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbgetentities} method calls, like
    #
    # ```ruby
    # api.wbgetentities.ids('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbgetentities} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbgetentities]
    #
    def wbgetentities
      Wbgetentities.new(client, @defaults)
    end

    # Associates two articles on two different wikis with a Wikibase item.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wblinktitles} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wblinktitles} method calls, like
    #
    # ```ruby
    # api.wblinktitles.tosite('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wblinktitles} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wblinktitles]
    #
    def wblinktitles
      Wblinktitles.new(client, @defaults)
    end

    # Merges multiple items.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbmergeitems} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbmergeitems} method calls, like
    #
    # ```ruby
    # api.wbmergeitems.fromid('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbmergeitems} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbmergeitems]
    #
    def wbmergeitems
      Wbmergeitems.new(client, @defaults)
    end

    # Parses values using a ValueParser.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbparsevalue} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbparsevalue} method calls, like
    #
    # ```ruby
    # api.wbparsevalue.datatype('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbparsevalue} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbparsevalue]
    #
    def wbparsevalue
      Wbparsevalue.new(client, @defaults)
    end

    # Removes Wikibase claims.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbremoveclaims} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbremoveclaims} method calls, like
    #
    # ```ruby
    # api.wbremoveclaims.claim('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbremoveclaims} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbremoveclaims]
    #
    def wbremoveclaims
      Wbremoveclaims.new(client, @defaults)
    end

    # Removes a qualifier from a claim.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbremovequalifiers} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbremovequalifiers} method calls, like
    #
    # ```ruby
    # api.wbremovequalifiers.claim('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbremovequalifiers} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbremovequalifiers]
    #
    def wbremovequalifiers
      Wbremovequalifiers.new(client, @defaults)
    end

    # Removes one or more references of the same statement.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbremovereferences} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbremovereferences} method calls, like
    #
    # ```ruby
    # api.wbremovereferences.statement('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbremovereferences} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbremovereferences]
    #
    def wbremovereferences
      Wbremovereferences.new(client, @defaults)
    end

    # Searches for entities using labels and aliases. Returns a label and description for the entity in the user language if possible. Returns details of the matched term. The matched term text is also present in the aliases key if different from the display label.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsearchentities} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsearchentities} method calls, like
    #
    # ```ruby
    # api.wbsearchentities.search('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsearchentities} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsearchentities]
    #
    def wbsearchentities
      Wbsearchentities.new(client, @defaults)
    end

    # Sets the aliases for a Wikibase entity.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetaliases} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetaliases} method calls, like
    #
    # ```ruby
    # api.wbsetaliases.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetaliases} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetaliases]
    #
    def wbsetaliases
      Wbsetaliases.new(client, @defaults)
    end

    # Creates or updates an entire Statement or Claim.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetclaim} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetclaim} method calls, like
    #
    # ```ruby
    # api.wbsetclaim.claim('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetclaim} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetclaim]
    #
    def wbsetclaim
      Wbsetclaim.new(client, @defaults)
    end

    # Sets the value of a Wikibase claim.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetclaimvalue} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetclaimvalue} method calls, like
    #
    # ```ruby
    # api.wbsetclaimvalue.claim('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetclaimvalue} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetclaimvalue]
    #
    def wbsetclaimvalue
      Wbsetclaimvalue.new(client, @defaults)
    end

    # Sets a description for a single Wikibase entity.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetdescription} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetdescription} method calls, like
    #
    # ```ruby
    # api.wbsetdescription.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetdescription} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetdescription]
    #
    def wbsetdescription
      Wbsetdescription.new(client, @defaults)
    end

    # Sets a label for a single Wikibase entity.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetlabel} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetlabel} method calls, like
    #
    # ```ruby
    # api.wbsetlabel.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetlabel} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetlabel]
    #
    def wbsetlabel
      Wbsetlabel.new(client, @defaults)
    end

    # Creates a qualifier or sets the value of an existing one.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetqualifier} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetqualifier} method calls, like
    #
    # ```ruby
    # api.wbsetqualifier.claim('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetqualifier} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetqualifier]
    #
    def wbsetqualifier
      Wbsetqualifier.new(client, @defaults)
    end

    # Creates a reference or sets the value of an existing one.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetreference} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetreference} method calls, like
    #
    # ```ruby
    # api.wbsetreference.statement('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetreference} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetreference]
    #
    def wbsetreference
      Wbsetreference.new(client, @defaults)
    end

    # Associates an article on a wiki with a Wikibase item or removes an already made such association.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsetsitelink} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetsitelink} method calls, like
    #
    # ```ruby
    # api.wbsetsitelink.id('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsetsitelink} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsetsitelink]
    #
    def wbsetsitelink
      Wbsetsitelink.new(client, @defaults)
    end

    # API module for getting suggestions of additional properties to add to a Wikibase entity. The API module is primarily intended for use by the suggester widget when users are editing Wikibase entities.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::Wbsgetsuggestions} action.
    #
    # Action parameters could be passed or by subsequent
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsgetsuggestions} method calls, like
    #
    # ```ruby
    # api.wbsgetsuggestions.entity('value')
    # ```
    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::Wbsgetsuggestions} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::Wbsgetsuggestions]
    #
    def wbsgetsuggestions
      Wbsgetsuggestions.new(client, @defaults)
    end

    # Returns a webapp manifest.
    #
    # This method creates an instance of {Reality::Describers::Wikidata::Impl::Actions::WebappManifest} action.
    #

    #
    # See {Reality::Describers::Wikidata::Impl::Actions::Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Actions::WebappManifest} class for a list of parameters and usage.
    #
    # @return [Reality::Describers::Wikidata::Impl::Actions::WebappManifest]
    #
    def webapp_manifest
      WebappManifest.new(client, @defaults)
    end
  end
end

Dir[File.expand_path('../{actions,modules}/*.rb', __FILE__)].each { |f| require f }

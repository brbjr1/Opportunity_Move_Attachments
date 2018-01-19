public with sharing class Opportunity_Move_AttachmentsCon 
{
	public OpportunityContactRole source {get;set;}
	public OpportunityContactRole dest {get;set;}
    public Opportunity_Move_AttachmentsCon() 
    {
    	source = new OpportunityContactRole();
    	if (System.currentPageReference().getParameters().get('oid') !=null)
    	{
    		source.OpportunityId = System.currentPageReference().getParameters().get('oid');
    	}
        dest = new OpportunityContactRole();
    }


    public PageReference CompleteMove()
    {

    	if (source == null || source.OpportunityId  ==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,  'You must select a source opportunity.'));

    	}
    	else if (dest ==null || dest.OpportunityId  ==null)
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,  'You must select a destination opportunity.'));
    	}
    	else
    	{
    		list<Attachment> sourceAttachments = new list<Attachment>([Select ID, ParentID, body, Name from Attachment Where ParentID = :source.OpportunityId ]);
    		list<Attachment> destinationAttachments = new list<Attachment>();
    		if (sourceAttachments.isEmpty() == false)
    		{
    			for(Attachment item : sourceAttachments)
    			{
    				destinationAttachments.add(New Attachment(Name = item.name, body = item.body, parentID = dest.OpportunityId));
    			}
    		}
	    	if (destinationAttachments.isEmpty() == false)
	    	{
	    		insert destinationAttachments;
	    		delete sourceAttachments;
	    	}
	    	//redirect to destionation opportunity
	    	PageReference p = new PageReference('/' + dest.OpportunityId);
	    	p.setRedirect(true);
	    	return p;
		}
		return null;
    }

    public PageReference Cancel()
    {
    	string url = '/';
    	if (source != null && source.OpportunityId != null)
    	{
            //redirect to source opportunity
    		url += source.OpportunityId;
    	}
    	PageReference p = new PageReference(url);
	    p.setRedirect(true);
	    return p;
    }
}
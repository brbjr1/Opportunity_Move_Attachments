@isTest
private class Opportunity_Move_AttachmentsConTest 
{
    static testMethod void testMethod1() 
    {
        Account a1 = new Account(Name= 'test');
        insert a1;

        Opportunity o1 = new Opportunity(AccountId = a1.Id, Name = 'Test', StageName = 'Test', CloseDate = date.today());
        insert o1;

        Opportunity o2 = new Opportunity(AccountId = a1.Id, Name = 'Test 2', StageName = 'Test', CloseDate = date.today());
        insert o2;


        Attachment att1 = new Attachment();
		att1.Body = Blob.valueOf('Test');
		att1.Name = 'Test.htm';
		att1.ParentId = o1.Id;
		insert att1;


		test.startTest();

		System.currentPageReference().getParameters().put('oid', o1.Id);

		Opportunity_Move_AttachmentsCon con = new Opportunity_Move_AttachmentsCon();
		con.dest.OpportunityId = o2.Id;
		con.CompleteMove();
		con.Cancel();

		test.stopTest();

		list<Attachment> test1 = new list<Attachment>([Select Id from Attachment where parentId = :o2.Id]);
		system.assertEquals(1, test1.size(), 'Error o2 attachment size should have been 1.');

    }
}
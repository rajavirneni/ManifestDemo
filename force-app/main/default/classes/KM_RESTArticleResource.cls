/* Class Name   : KM_RESTArticleResource is an encasulation of REST resource for Knowlege Article
 * Project / CR:  KM Implementation
 * Description  : Controller for restful call for Article
 * Created By   : Ivan Yeung
 * Created On   : 4/20/2015

 * end point: https://instance.salesforce.com/services/apexrest/Article

 * Note: this rest controller is trying to follow the best practice of REST API implementation captured by Roy Thomas Fielding
 * ref: https://www.youtube.com/watch?v=ZpqCN8iO9Y8
 * Uniform interface 
 *      1. Identification of resources - Article(s)
 *      2. Manipulations of these resources 
           Ideally, we can take advantage of different URL endpoints: 
                e.g. 
                SearchArticle : URI = https://instance.salesforce.com/services/apexrest/Article  ; method: GET
                CreateArticle : URI = https://instance.salesforce.com/services/apexrest/Article ; method: POST
                RetreiveArticleByID : URI = https://instance.salesforce.com/services/apexrest/Article/{articleID} ; method: GET
         
                  
 *      3. Self Descriptive
 *      4. Hyermedia as the engine of application state: SubResourceUris  - it can be useful for AEM integrations
 
 * Note: Secure coding guideline should be followed (e.g. use escapeSingleQuotes )
 * ref: https://developer.salesforce.com/page/Secure_Coding_Guideline


 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date                   Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 */
@RestResource(urlMapping='/Article/*')
global with sharing class  KM_RESTArticleResource
{

	// ArticleRESTResponse is the custom Response definiton sent back to POST operation 
	global class ArticleRESTResponse {

        public String status { get; set; }
        public Id artileID { get; set; } // internal Article ID in salesforce
        public String articleExtId { get; set; }  // External Article ID in salesforce

    }


	/*
		This method has no fixed input parameter,  the HTTP request body is copied into the RestRequest.requestBody instead

		The parameter format is as follows:
		<article>	

		</article>

	*/    
    @HttpPost
    global static ArticleRESTResponse doPost() {

        RestRequest req = RestContext.request;  
        RestResponse res = RestContext.response;

        System.debug(LoggingLevel.DEBUG, 'KM_RESTArticleResource::doGet:' + req.requestBody.toString());


        // To do: create service class to handle prasing and creation of article 
        Dom.Document requestDoc = new Dom.Document();
        requestDoc.load(req.requestBody.toString());

		//Retrieve the root element for this document.
        Dom.XMLNode eRoot = requestDoc.getRootElement();


    	ArticleRESTResponse result = new ArticleRESTResponse(); 
    	result.status = 'SUCCESS'; 


        return result;
    }



	
	/*
		Methods annotated with @HttpGet should have no parameters. This is because GET have no request body
	*/
    @HttpGet
    global static sObject doGet() {
        RestRequest req = RestContext.request;  
        RestResponse res = RestContext.response;
        String articleExtId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug(LoggingLevel.DEBUG, 'KM_RESTArticleResource::doGet:'  + 'requestURI = ' +  req.requestURI ); 
		System.debug(LoggingLevel.DEBUG, 'KM_RESTArticleResource::doGet:'  + 'articleExtId = ' +  articleExtId ); 


		String sLanguage = req.params.get('Language');	
		if (sLanguage == null || sLanguage.length() == 0){
			sLanguage = 'en_US'; // set default language to US
		} 

        // To do: create new selector class to use all article types dynamically. 
		String articleTypeAPIName = 'Solution__kav';
		String articleFieldList = 'ArticleNumber, ArticleType, PublishStatus, Summary, Title,  VersionNumber, Legacy_ID__c,	Problem__c, Solution__c ';


        Id articleVersionId; 
		String searchquery='FIND '; 
		searchquery += '\'' + String.escapeSingleQuotes(articleExtId)  + '\' IN ALL FIELDS RETURNING '; 
		searchquery += articleTypeAPIName + '(Id, ArticleType WHERE PublishStatus=\'Online\' AND Language=\''+ sLanguage +  '\')'; 
		List<List<SObject>>searchList=search.query(searchquery);
		for (List<SObject> onlineArticleList:  searchList   ){
			// process the first list 
			for (SObject onlineArticle :onlineArticleList ){
				articleVersionId = 	onlineArticle.Id; 
			}
		}
		System.debug(LoggingLevel.DEBUG, 'KM_RESTArticleResource::doGet:'  + 'articleVersionId = ' +  articleVersionId ); 


		String dbquery = 'SELECT ' + articleFieldList + ' FROM ' + articleTypeAPIName + ' where Id = ' + '\'' + articleVersionId + '\'' ; 
		System.debug(LoggingLevel.DEBUG, 'KM_RESTArticleResource::doGet:'  + 'dbquery = ' +  dbquery ); 
		List<sObject> articleVersionList = Database.query(dbquery);

		if (articleVersionList.size() >0){
			return articleVersionList[0]; 
		} 			
			return null; 
    }

}
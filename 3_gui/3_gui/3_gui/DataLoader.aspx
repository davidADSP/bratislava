<%@ Page Title="Hometrue" Language="C#" AutoEventWireup="true" %>

<script runat="server">
            public void Page_Load(object sender, EventArgs e)
            {
                if (this.IsPostBack)
                {
                    string response = "";
                    string queryMethod = Request.QueryString["method"];
                    if (queryMethod == "getpreds")
                    {
                        var prms = new List<RfacadeTool.RRequestParameter>();
                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "propertyType",
                            Value = Request.Form["propertyType"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                        });

                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "street",
                            Value = Request.Form["street"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                        });

                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "bedrooms",
                            Value = Request.Form["bedrooms"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                        });


                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "bathrooms",
                            Value = Request.Form["bathrooms"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                        });

                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "recepts",
                            Value = Request.Form["recepts"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                        });


                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "floors",
                            Value = Request.Form["floors"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                        });

                        prms.Add(new RfacadeTool.RRequestParameter()
                        {
                            Name = "description",
                            Value = Request.Form["description"].Replace("{", "").Replace("}", "").Replace("\"", "").Replace("'", "")
                    });


                    prms.Add(new RfacadeTool.RRequestParameter()
                    {
                        Name = "price",
                        Value = Request.Form["price"]
                    });

                    RfacadeTool.RFacade rf = new RfacadeTool.RFacade();
                    response = rf.MakeRRequest(queryMethod, prms);
                }
                Response.Clear();
                Response.ClearHeaders();
                Response.ClearContent();
                Response.Write(response);
                Response.End();

            }
        else
        {
            string queryMethod = Request.QueryString["method"];
            RfacadeTool.RFacade rf = new RfacadeTool.RFacade();
            rf.ClearCache();
            string response = rf.MakeRRequest(queryMethod, new List<RfacadeTool.RRequestParameter>());
            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();
            Response.Write(response);
            Response.End();
        }
    }
</script>

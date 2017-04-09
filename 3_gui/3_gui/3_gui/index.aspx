<%@ Page Title="Hometrue" Language="C#" AutoEventWireup="true" %>

<script runat="server">
    public void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod == "POST")
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
                rf.ClearCache();
                response = rf.MakeRRequest(queryMethod, prms);
            }
            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();
            Response.Write(response);
            Response.End();

        }
    }
</script>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Hometrue</title>

    <!-- Bootstrap Core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/jquery-ui.css" rel="stylesheet">
    <link href="css/jquery-ui.structure.css" rel="stylesheet">
    <link href="css/jquery-ui.theme.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">

    <!-- Theme CSS -->
    <link href="css/grayscale.min.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
        input, select, textarea {
            background-color: #ffffff;
            color: #000000;
            border: solid 3px #808080;
        }

        option {
            background-color: #ffffff;
            color: #000000;
        }

        .invalidControl {
            border: solid 3px #cd3737;
        }

        .ui-autocomplete {
            max-height: 100px;
            overflow-y: auto;
            /* prevent horizontal scrollbar */
            overflow-x: hidden;
        }

        .option_placeholder {
            color: #808080;
        }

        #offeredPrice {
            color: #ff0000;
        }

        #forecastedValue {
            color: #3498DB;
        }

        #offeredPrice2 {
            color: #ff0000;
        }

        #forecastedValue2 {
            color: #3498DB;
        }

        #forecastedValue3 {
            color: #3498DB;
        }

        .wtifimg {
            margin: 6px;
            opacity: 0.8;
            border: solid 1px #000000;
            padding: 3px;
            cursor: pointer;
        }

            .wtifimg:hover {
                margin: 6px;
                padding: 3px;
                opacity: 0.8;
                border: solid 1px #cfcfcf;
            }

        .optdiv {
            text-align: left;
        }
    </style>
</head>

<body id="page-top" data-spy="scroll" data-target=".navbar-fixed-top" style="font-family: Verdana">

    <!-- Navigation -->
    <nav class="navbar navbar-custom navbar-fixed-top" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse">
                    Menu <i class="fa fa-bars"></i>
                </button>
                <a class="navbar-brand page-scroll" href="#page-top">
                    <i class="fa fa-play-circle"></i><span class="light">&nbsp;hometruth</span>
                </a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse navbar-right navbar-main-collapse">
                <ul class="nav navbar-nav">
                    <!-- Hidden li included to remove active class from about link when scrolled up past about section -->
                    <li class="hidden">
                        <a href="#page-top"></a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#about">About</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#letustellyou">Let us tell you..</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#improvedescription">What if?</a>
                    </li>

                    <li>
                        <a class="page-scroll" href="#contactus">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <!-- Intro Header -->

    <header class="intro" id="about">
        <div class="intro-body">
            <div class="container">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <div>
                            <img src="img/logo.png" style="height: 30%; width: 30%" />
                        </div>
                        <h1 class="brand-heading">Hometruth</h1>
                        <p class="intro-text">Minimize your risk of selling property at a bad price.</p>
                        <a href="#letustellyou" class="btn btn-circle page-scroll">
                            <i class="fa fa-angle-double-down animated"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- About Section -->
    <section id="letustellyou" class="container content-section text-center">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <h2>Let us tell you...</h2>
                <p>Whether you should accept the offer you were given...</p>
                <p>How the value of you property will look like in next few weeks</p>
                <p>What can you do to increase your property value.</p>
                <p>When you are ready...let's <a href="#formdata">GO</a></p>
            </div>
        </div>
    </section>



    <section id="formdata" class="container content-section text-center" style="padding-top: 150px;">
        <div style="font-family: Verdana">
            <p>Stay with us, it will take a moment to fill this form:</p>
            <div class="col-lg-8 col-lg-offset-1">

                <div class="container">
                    <div class="form-group row">
                        <label for="areaInput" class="col-sm-2 col-form-label">Area</label>
                        <input id="areaInput" class="col-md-6" type="text" placeholder="London - 5 mile area" disabled="disabled" placeholder="Area" />
                    </div>


                    <div class="form-group row">
                        <label for="propertyTypeInput" class="col-sm-2 col-form-label">Property type</label>
                        <select id="propertyTypeInput" class="col-md-6 col-form-label">
                        </select>
                    </div>

                    <div class="form-group row">
                        <label for="streetInput" class="col-sm-2 col-form-label">Street</label>
                        <input id="streetInput" class="col-md-6 col-form-label" placeholder="Type the street where your property resides" />

                    </div>

                    <div class="form-group row">
                        <label for="bedInput" class="col-sm-2 col-form-label">Bedroom</label>
                        <select id="bedInput" class="col-md-2 col-form-label">
                        </select>

                        <label for="bathInput" class="col-sm-2 col-form-label">Bathroom</label>
                        <select id="bathInput" class="col-md-2 col-form-label">
                        </select>
                    </div>



                    <div class="form-group row">
                        <label for="numFloors" class="col-sm-2 col-form-label">Floors</label>
                        <select id="numFloors" class="col-md-2 col-form-label">
                        </select>

                        <label for="numRecepts" class="col-sm-2 col-form-label">Reception rooms</label>
                        <select id="numRecepts" class="col-md-2 col-form-label">
                        </select>
                    </div>


                    <div class="form-group row">
                        <label for="descInput" class="col-sm-2 col-form-label">Description</label>
                        <textarea id="descInput" class="col-md-6" rows="8" placeholder="The description of your property"></textarea>
                    </div>

                    <p>
                        And finaly, the offer you have been given:
                    </p>
                    <div class="form-group row">
                        <label for="givenPriceInput" class="col-sm-2 col-form-label">Price</label>
                        <input id="givenPriceInput" class="col-md-4" type="text" placeholder="Price in € like 100,000" />
                        <input id="startCalculationBtn" type="button" class="col-lg-offset-1 col-md-1" value="GO!" />
                    </div>

                </div>
            </div>
        </div>
    </section>




    <section id="results" class="container content-section text-center">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <h2>You have told us that the offered value for your property is <span id="offeredPrice"></span></h2>
                <p>Our tool predicted that your property is worth <span id="forecastedValue"></span></p>
                <p>This makes the decision easy:</p>
                <div>
                    <img id="decisionImg" src="img/logo.png" style="height: 35%; width: 35%" />
                </div>
                <p>But wait, there's more! Let's increase your property value (insurance policy covered)! <a href="#improvedescription">GO</a></p>
            </div>
        </div>
    </section>


    <section id="improvedescription" class="container content-section text-center">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <h2>The What If?</h2>
                <p>Try playing with options (click on icon to add / remove features) - see how much you can improve your property value by making upgrades.</p>
                <p>:)</p>
                <div class="row">

                    <div class="col-lg-6 optionsDiv optdiv" id="optionsDiv" style="height: 225px;">
                        <div style="text-align: center">
                            <p>Options</p>
                        </div>
                        <img class="wtifimg" src="img/black-bed.png" title="Master bedroom" />
                        <img class="wtifimg" src="img/economic-architecture-building-of-stacked-containers.png" title="Open plan" />
                        <img class="wtifimg" src="img/home-building-like-a-birds-house.png" title="From aspect" />
                        <img class="wtifimg" src="img/table-and-two-chairs-set-for-back-yard.png" title="Fitted kitchen" />
                        <img class="wtifimg" src="img/black-bed.png" title="Master bedroom" />
                        <img class="wtifimg" src="img/electric-plugins-of-wall.png" title="Power points" />

                        <img class="wtifimg" src="img/livingroom-black-curtains.png" title="Central heating" />

                        <img class="wtifimg" src="img/picture-with-frame-for-livingroom-decoration-of-house.png" title="Double glazed" />

                        <img class="wtifimg" src="img/bathtub-with-opened-shower.png" title="Family bathroom" />

                        <img class="wtifimg" src="img/fence.png" title="Rear garden" />

                        <img class="wtifimg" src="img/hotel-receptionist.png" title="Reception room" />

                        <img class="wtifimg" src="img/shower.png" title="Shower room" />

                        <img class="wtifimg" src="img/sword.png" title="Stainless steel" />

                        <img class="wtifimg" src="img/parking-sign.png" title="Street parking" />

                        <img class="wtifimg" src="img/tiles.png" title="Tiled walls" />

                        <img class="wtifimg" src="img/railroad-with-wood-planks.png" title="Transport links" />

                        <img class="wtifimg" src="img/bedroomplusone.png" title="Add another bedroom" />

                        <img class="wtifimg" src="img/bathtubplusone.png" title="Add another bath" />

                    </div>
                    <div class="col-lg-6 addOnDiv optdiv" id="addOnDiv">
                        <div style="text-align: center">
                            <p>Addons</p>
                        </div>

                    </div>



                </div>




            </div>
        </div>
        <div class="row">

            <div class="col-lg-4 optionsDiv col-lg-offset-2">
                <p>Forecasted:&nbsp;<span id="forecastedValue2">___________</span></p>
            </div>

            <div class="col-lg-4 optionsDiv col-lg-offset-1">
                <p>With addons:&nbsp;<span id="forecastedValue3">___________</span></p>
            </div>




        </div>
        <p>When you are ready...let's <a href="javascript:reforecast();">GO</a></p>
    </section>


    <!-- Contact Section -->
    <section id="contactus" class="container content-section text-center">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <h2>Contact Hometrue</h2>
                <p>Feel free to email us to provide some feedback on out tool, give us suggestions for new features or let us help you sell or insure your property for right amount!</p>
                <p>
                    <a href="mailto:feedback@startbootstrap.com">fools_and_horses@london.com</a>
                </p>


                <p>
                    The code for scraping, data, mining models and gui you can download from <a href="https://github.com/davidADSP/bratislava">https://github.com/davidADSP/bratislava</a>
                </p>
            </div>
        </div>
    </section>
    <!-- Map Section -->
    <div id="map"></div>
    <!-- Footer -->
    <footer>
        <div class="container text-center">
            <p>Copyright &copy; www.hometrue.me</p>
        </div>
    </footer>

    <div id="waitingDialog" class="hidden" style="padding: 15px;">
        <p>Hej, give us a moment of two</p>
        <div class="progress">
            <div class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="100"
                aria-valuemin="0" aria-valuemax="100" style="width: 100%">
                Crunching those text and numbers!
            </div>
        </div>
    </div>


    <!-- jQuery -->
    <script src="vendor/jquery/jquery.js"></script>
    <!-- Bootstrap Core JavaScript -->
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>
    <!-- Plugin JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
    <!-- Google Maps API Key - Use your own API key to enable the map feature. More information on the Google Maps API can be found at https://developers.google.com/maps/ -->
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCRngKslUGJTlibkQ3FkfTxj3Xss1UlZDA&sensor=false"></script>
    <!-- Theme JavaScript -->
    <script src="js/grayscale.min.js"></script>


    <script src="Scripts/jquery-ui.js"></script>
    <script src="Scripts/JAjaxProcessor.js"></script>




    <script>
        function populateSelectBox(method, theId, placeHolderText) {
            if (typeof (placeHolderText) == "undefined" || placeHolderText == null) {
                placeHolderText = "";
            }
            //load property types
            var res = $.ajax({
                type: "GET",
                async: false,
                url: "DataLoader.aspx?method=" + method,
                success: function (data) {
                    return data;
                }
            });

            var rows = JSON.parse(res.responseText);
            var html = "<option class='option_placeholder' value=''>" + placeHolderText + "</option>";
            for (var i = 0; i < rows.length; i++) {
                html += "<option name='" + rows[i].value + "'>" + rows[i].name + "</option>"
            }
            $("#" + theId).html(html);
            $("#" + theId).change(function () {
                var sl = $(this);
                sl.removeClass("option_placeholder");
                if (sl.val() == "") {
                    sl.addClass("option_placeholder");
                }
            }).trigger("change");
        }

        var progress_bar_value = 0;
        var progress_interval = null;
        function showDialog() {
            var waitingDialog = $("#waitingDialog").dialog({
                modal: true,
                buttons: {},
                title: 'Loading.....',
                minHeight: 180,
                minWidth: 430,
                resizable: false,
                closeOnEscape: false,
            });
            $("#waitingDialog").find("progress-bar").attr("aria-valuenow", "0");
            $("#waitingDialog").removeClass("hidden");
            $(".ui-dialog-titlebar").hide();
            //run interval function
        }

        function hideDialog() {
            clearInterval(progress_interval);
            $("#waitingDialog").dialog("close");
        }

        var last_forecasted_object = null;
        $(document).ready(function () {

            //setup search boxes
            $("#streetInput").autocomplete({
                minLength: 3,
                select: function (ev, ui) {
                    $("#streetInput").val(ui.item.label);
                    return false;
                },
                source: function (request, response) {
                    var term = request.term;
                    var parsed = [];
                    var ap = new AjaxProcessor();

                    var res = $.ajax({
                        type: "GET",
                        async: false,
                        url: "DataLoader.aspx?method=getUniqueStreets;" + term,
                        success: function (data) {
                            return data;
                        }
                    });

                    var rows = JSON.parse(res.responseText);
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        parsed[parsed.length] = {
                            id: row.label,
                            value: row.value,
                            label: row.name
                        };
                    }
                    response(parsed);
                }

            });

            populateSelectBox("getUniqueBathrooms", "bathInput", "No of bathrooms");
            populateSelectBox("getUniqueBedrooms", "bedInput", "No of bedrooms");
            populateSelectBox("getUniqueNumOfFloors", "numFloors", "No of floors");
            populateSelectBox("getUniqueNumOfRecepts", "numRecepts", "No of recepts");
            populateSelectBox("getUniquePropertyTypes", "propertyTypeInput", "The type of your property");

            $("#startCalculationBtn").click(function () {
                $(".invalidControl").removeClass("invalidControl");
                postObj = {};
                postObj.propertyType = $("#propertyTypeInput").val();
                postObj.street = $("#streetInput").val();
                postObj.bedrooms = $("#bedInput").val();
                postObj.bathrooms = $("#bathInput").val();
                postObj.recepts = $("#numRecepts").val();
                postObj.floors = $("#numFloors").val();
                postObj.description = $("#descInput").val();
                postObj.price = $("#givenPriceInput").val().replace(",", "");

                if (postObj.propertyType == "") $("#propertyTypeInput").addClass("invalidControl");
                if (postObj.street == "") $("#streetInput").addClass("invalidControl");
                if (postObj.bedrooms == "") $("#bedInput").addClass("invalidControl");
                if (postObj.bathrooms == "") $("#bathInput").addClass("invalidControl");
                if (postObj.recepts == "") $("#numRecepts").addClass("invalidControl");
                if (postObj.floors == "") $("#numFloors").addClass("invalidControl");
                if (postObj.description == "") $("#descInput").addClass("invalidControl");
                if (postObj.price == "") $("#givenPriceInput").addClass("invalidControl");

                if ($(".invalidControl").length > 0) return false;
                showDialog();
                //running model
                var res = $.ajax({
                    type: "POST",
                    async: false,
                    url: "?method=getpreds",
                    data: postObj,
                    success: function (data) {
                        res = data;
                        last_forecasted_object = postObj;
                        var forecastedObj = JSON.parse(res);
                        var actualPrice = parseFloat(postObj.price);
                        var forecastedPrice = parseFloat(forecastedObj[0].value);
                        if (forecastedPrice < actualPrice * 0.98) {
                            $("#decisionImg").attr("src", "/img/logo_sell.png");
                        } else {
                            $("#decisionImg").attr("src", "/img/logo_keep.png");
                        }
                        $("#offeredPrice").text(postObj.price);
                        $("#forecastedValue").text(forecastedObj[0].value);
                        $("#offeredPrice2").text(postObj.price);
                        $("#forecastedValue2").text(forecastedObj[0].value);
                        window.location.href = "#results";
                    }
                });
                hideDialog();

            });

            moveImage = function (ex) {
                var el = $(ex);
                var divEl = el.parents("div").first();
                var newImg = $(el[0].outerHTML)
                newImg.click(function (ex) { moveImage(this) });
                el.remove();
                if (divEl.hasClass("addOnDiv")) {
                    $("#optionsDiv").append(newImg);
                } else {
                    $("#addOnDiv").append(newImg);
                }
            }

            $(".wtifimg").click(function () {
                moveImage(this);
            });

        });

        function reforecast() {
            if (last_forecasted_object == null) return;
            var newObj = JSON.parse(JSON.stringify(last_forecasted_object));;

            newObj.bathrooms = parseInt(newObj.bathrooms);
            newObj.bedrooms = parseInt(newObj.bedrooms);
            //addon keywords
            $("#addOnDiv").find(".wtifimg").each(function (i, el) {
                var tit = $(el).attr("title");
                if (tit == "Add another bedroom") newObj.bedrooms = newObj.bedrooms + 1;
                else if (tit == "Add another bath") newObj.bathrooms = newObj.bathrooms + 1;
                else
                    newObj.description = newObj.description + " " + tit;
            });

            showDialog();
            //running model
            var res = $.ajax({
                type: "POST",
                async: false,
                url: "?method=getpreds",
                data: newObj,
                success: function (data) {
                    return data;
                }
            });
            hideDialog();
            var forecastedObj = JSON.parse(res.responseText);
            var actualPrice = parseFloat(postObj.price);
            var forecastedPrice = parseFloat(forecastedObj[0].value);
            $("#forecastedValue3").text(forecastedPrice);
            $("#forecastedValue3").fadeIn(300).fadeOut(300).fadeIn(300);
        }








    </script>


</body>

</html>

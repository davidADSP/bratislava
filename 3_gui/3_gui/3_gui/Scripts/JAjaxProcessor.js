/*
Jebboo trace console
*/
var JEEBOO_RECORDER_STATE = true;
var JEEBOO_RECORDER_TARGET_FRAME = window.top.frames["trace"];

///<summary>
/// The ajax processor constructor
///</summary>
function AjaxProcessor(formID) {
    this._formID = (formID == undefined ? null : formID);
}

///<summary>
/// retreives the form element by providing optional id
///</summary>
AjaxProcessor.prototype.getFormElement = function() {
    var _id = null;
    if (this._formID != null)
        _id = "#" + this._formID;
    else _id = "form";
    return $(_id);
}

///<summary>
/// retreives the form element url
///</summary>
AjaxProcessor.prototype.getFormUrl = function() {
    var _id = null;
    if (this._formID != null)
        _id = "#" + this._formID;
    else _id = "form";
    var url = $(_id).filter(":first").attr("action");
    return url;
}

///<summary>
/// Gets the post data
///</summary>
AjaxProcessor.prototype.getPostData = function() {
    var postData = {};
    var $foo = this.getFormElement().find("input,textarea,select,hidden");
    for (var i = 0, n = $foo.length; i < n; ++i) {
        var element = $foo[i];
        if (element.tagName == 'INPUT' && element.type == 'checkbox') {
            postData[$(element).attr("name")] = (element.checked ? "checked" : "");
            continue;
        }

        if (element.tagName == 'INPUT' &&
                    element.type == 'radio' &&
                    element.checked) {
            postData[$(element).attr("name")] = $(element).val();
            continue;
        }

        /*for the auto complete stuff*/
        if (element.tagName == 'INPUT' && $(element).attr("in_autocomplete") != null || $(element).attr("in_autocomplete") != undefined) {
            postData[$(element).attr("name")] = $(element).attr("selvalue");
            continue;
        }

        postData[$(element).attr("name")] = $(element).val();

    }
    postData["__CALLBACKID"] = "__Page";
    postData["__CALLBACKPARAM"] = "SaveModel";
    return postData;
}



///<summary>
/// Sends request to execute server method
///</summary
AjaxProcessor.prototype.invokeMethod = function(_methodName,
                                                     callBackFunc,
                                                     callBackParam_1,
                                                     callBackParam_2,
                                                     callBackParam_3,
                                                     callBackParam_4,
                                                     callBackParam_5,
                                                     callBackParam_6,
                                                     callBackParam_7
                                                     ) {
    var isAsync = (callBackFunc == undefined || callBackFunc == null ? false : true);
 
    var res =
                this.performAjaxRequest({
                    action: "ExecuteMethod",
                    _AjaxCallBackParam_0: _methodName,
                    _AjaxCallBackParam_1: callBackParam_1,
                    _AjaxCallBackParam_2: callBackParam_2,
                    _AjaxCallBackParam_3: callBackParam_3,
                    _AjaxCallBackParam_4: callBackParam_4,
                    _AjaxCallBackParam_5: callBackParam_5,
                    _AjaxCallBackParam_6: callBackParam_6,
                    _AjaxCallBackParam_7:callBackParam_7,
                    onSucess: callBackFunc,
                    async: isAsync
                });
    res = res.substring(res.indexOf("__cblResult=") + 12);
    return res;
}

///<summary>
/// Sends request to get value of the property on the page or model or controler
/// <param>_propertyName : the name of the property to retreive, prefix with Page. for page scope otherwise the 
///        system will look at the controler scope.</param>
/// <param>_propertyIndexOrNull : if the value property is indexed send the index value here</param>
/// <param>callBackFunc : the javascript function pointer to call when server result arrives.</param>
///</summary
AjaxProcessor.prototype.getProperty = function(_propertyName,
                                                       _propertyIndexOrNull, // if indexed property this would be the index
                                                       callBackFunc
                                                       ) {
    var isAsync = (callBackFunc == undefined || callBackFunc == null ? false : true);
    var res =
                this.performAjaxRequest({
                    action: "GetProperty",
                    _AjaxCallBackParam_0: _propertyName,
                    _AjaxCallBackParam_1: _propertyIndexOrNull,
                    onSucess: callBackFunc,
                    async: isAsync
                });
    res = res.substring(res.indexOf("__cblResult=") + 12);
    return res;
}



///<summary>
/// Sends request to set value of the property on the page or model or controler. Returns true if there was no error
/// otherwise returns false
/// <param>_propertyName : the name of the property to retreive, prefix with Page. for page scope otherwise the 
///        system will look at the controler scope.</param>
/// <param>_propertyValue : the value of the property to set.</param>
/// <param>_propertyIndexOrNull : if the value property is indexed send the index value here</param>
/// <param>callBackFunc : the javascript function pointer to call when server result arrives.</param>
///</summary
AjaxProcessor.prototype.setProperty = function(_propertyName,
                                                       _propertyValue,
                                                       _propertyIndexOrNull,
                                                       callBackFunc
                                                      ) {
    var isAsync = (callBackFunc == undefined || callBackFunc == null ? false : true);
    var res =
                this.performAjaxRequest({
                    action: "SetProperty",
                    _AjaxCallBackParam_0: _propertyName,
                    _AjaxCallBackParam_1: _propertyValue,
                    _AjaxCallBackParam_2: _propertyIndexOrNull,
                    onSucess: callBackFunc,
                    async: isAsync
                });
    res = res.substring(res.indexOf("__cblResult=") + 12);
    if (res == null || res == undefined) return false;
    return (res == 'OK');
}

///<summary>
/// Sends request to reload control
///</summary
AjaxProcessor.prototype.reloadControl = function(_controlID,
                                                         callBackFunc,
                                                         callBackParam_1,
                                                         callBackParam_2,
                                                         callBackParam_3,
                                                         callBackParam_4,
                                                         callBackParam_5,
                                                         callBackParam_6,
                                                         callBackParam_7
                                                         ) {

    var isAsync = (callBackFunc == undefined || callBackFunc == null ? false : true);
    var res =
            this.performAjaxRequest({
                action: "ReloadControl",
                _AjaxCallBackParam_0: _controlID,
                _AjaxCallBackParam_1: callBackParam_1,
                _AjaxCallBackParam_2: callBackParam_2,
                _AjaxCallBackParam_3: callBackParam_3,
                _AjaxCallBackParam_4: callBackParam_4,
                _AjaxCallBackParam_5: callBackParam_5,
                _AjaxCallBackParam_6: callBackParam_6,
                _AjaxCallBackParam_7:callBackParam_7,
                onSucess: (!isAsync ? null : callBackFunc),
                async: isAsync
            });
    res = res.substring(res.indexOf("__cblResult=") + 12);
    if (res == null || res == undefined) return false;
    return res;
}
///<summary>
/// Sends request to reload control
///</summary
AjaxProcessor.prototype.reloadForm = function (newurl, _controlID,
                                                         callBackFunc,
                                                         callBackParam_1,
                                                         callBackParam_2,
                                                         callBackParam_3,
                                                         callBackParam_4,
                                                         callBackParam_5,
                                                         callBackParam_6
                                                         ) {

    var isAsync = (callBackFunc == undefined || callBackFunc == null ? false : true);
    debugger;
    var res =
            this.performAjaxRequest({ url: newurl,
                action: "ReloadControl",
                _AjaxCallBackParam_0: _controlID,
                _AjaxCallBackParam_1: callBackParam_1,
                _AjaxCallBackParam_2: callBackParam_2,
                _AjaxCallBackParam_3: callBackParam_3,
                _AjaxCallBackParam_4: callBackParam_4,
                _AjaxCallBackParam_5: callBackParam_5,
                _AjaxCallBackParam_6: callBackParam_6,
                onSucess: (!isAsync ? null : callBackFunc),
                async: isAsync
            });
    res = res.substring(res.indexOf("__cblResult=") + 12);
    if (res == null || res == undefined) return false;
    return res;
}


///<summary>
/// The base method for all jeeboo ajax requests
///</summary
AjaxProcessor.prototype.performAjaxRequest = function (request) {
    if (request.postData == undefined || request.postData == null)
        request.postData = this.getPostData();
    /*callbackParam*/
    if (request.action == undefined || request.action == null)
        request.action == "SaveModel";
    request.postData["__CALLBACKPARAM"] = request.action;
    /*target control id*/
    if (request.target == undefined || request.target == null)
        request.target = "__Page";
    request.postData["__CALLBACKID"] = request.target;
    /*the parameters*/
    if (!(request._AjaxCallBackParam_0 == undefined || request._AjaxCallBackParam_0 == null))
        request.postData["_AjaxCallBackParam_0"] = request._AjaxCallBackParam_0;
    if (!(request._AjaxCallBackParam_1 == undefined || request._AjaxCallBackParam_1 == null))
        request.postData["_AjaxCallBackParam_1"] = request._AjaxCallBackParam_1;
    if (!(request._AjaxCallBackParam_2 == undefined || request._AjaxCallBackParam_2 == null))
        request.postData["_AjaxCallBackParam_2"] = request._AjaxCallBackParam_2;
    if (!(request._AjaxCallBackParam_3 == undefined || request._AjaxCallBackParam_3 == null))
        request.postData["_AjaxCallBackParam_3"] = request._AjaxCallBackParam_3;
    if (!(request._AjaxCallBackParam_4 == undefined || request._AjaxCallBackParam_4 == null))
        request.postData["_AjaxCallBackParam_4"] = request._AjaxCallBackParam_4;
    if (!(request._AjaxCallBackParam_5 == undefined || request._AjaxCallBackParam_5 == null))
        request.postData["_AjaxCallBackParam_5"] = request._AjaxCallBackParam_5;
    if (!(request._AjaxCallBackParam_6 == undefined || request._AjaxCallBackParam_6 == null))
        request.postData["_AjaxCallBackParam_6"] = request._AjaxCallBackParam_6;
    if (!(request._AjaxCallBackParam_7 == undefined || request._AjaxCallBackParam_7 == null))
        request.postData["_AjaxCallBackParam_7"] = request._AjaxCallBackParam_7;
    var _url = null;
    var _method = null;
    if (request.url == undefined || request.url == null)
        _url = this.getFormUrl();
    else
        _url = request.url;

    /*the aspnet viewstate functions*/
    request.postData["__VIEWSTATE"] = $("#__VIEWSTATE").attr("value");

    if (request.method == undefined || request.method == null)
        _method = "POST";
    else {
        _method = request.method;
        if (_method == "GET")
            request.postData = null;
    }
    var contextElem = null;
    if (!(request.contextElem == undefined || request.contextElem == null))
        contextElem = request.contextElem;

    //getting the jeebo trace
    /*
    this is used for tracing and load testing
    */
    if (JEEBOO_RECORDER_STATE != undefined && JEEBOO_RECORDER_STATE && JEEBOO_RECORDER_TARGET_FRAME != null) {
        var trace = "REQUEST; " + _method + ";" + window.location.protocol + "//" + window.location.host;

        var tempUrl = _url;
        if (tempUrl.indexOf("/") < 1) {
            tempUrl = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) + "/" + tempUrl;

        }

        else tempUrl = "/" + _url;
        trace += tempUrl;


        if (_method == "POST") {
            trace += ";";
            var index = 0;
            for (var pd in request.postData) {
                trace += (index == 0 ? "" : "; ") + pd + "=" + (pd == "__VIEWSTATE" ? "" : request.postData[pd]);
                index++;
            }
        }
        var doc = JEEBOO_RECORDER_TARGET_FRAME.document.body;
        var txt = $(doc).html();
        if (txt == null) txt = "";
        txt += "<br>" + trace;
        $(doc).html(txt);
    }
    var responseData = null;
    /*do ajax request*/
    $.ajax({
        type: _method,
        async: (request.async == undefined || request.async == null ? true : request.async),
        url: _url,
        data: request.postData,
        success: function (data) {
            responseData = data;
            /*check if return data starts with */
            if (data.substring(0, 1) == 'e') //exception occured
                alert(data.substring(1));
            /*check for call back*/
            if (request.onSucess != undefined || request.onSucess != null) {
                if (contextElem != null)
                    request.onSucess(data, contextElem);
                else request.onSucess(data);
            }
            return data;
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

            if (request.onError != undefined || request.onError != null) request.onError(XMLHttpRequest, textStatus, errorThrown);
            else {
                if (textStatus == "error" && errorThrown.toString().indexOf("Component returned failure code: 0x80004005 (NS_ERROR_FAILURE)") == -1) {
                    if (XMLHttpRequest.responseText != undefined) {
                        if (XMLHttpRequest.responseText.indexOf("session has expired") > 0)
                            alert("The session has expired!");
                        else
                            alert(errorThrown.toString());
                    }
                }
                else if (textStatus == "error" && errorThrown.toString().indexOf("Component returned failure code: 0x80004005 (NS_ERROR_FAILURE)") != -1) {
                    //do nothing
                }
                else
                    alert(textStatus);
            }
        }
    });
    return responseData;
    /*end of ajax request*/
}
    
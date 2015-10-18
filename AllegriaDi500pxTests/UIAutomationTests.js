var target = UIATarget.localTarget();

function navBarTitle() {
    return target.frontMostApp().navigationBar().staticTexts()[0].value();
}

function eval500pxTitle() {
    target.delay(1);
    if(navBarTitle() == "500px") {
        UIALogger.logPass("Title is 500px");
    } else {
        UIALogger.logFail("Title is incorrect: " + navBarTitle() + " instead of 500px");
    }
}

function evalPopularTitle() {
    target.delay(1);
    if(navBarTitle() == "popular") {
        UIALogger.logPass("Title is popular");
    } else {
        UIALogger.logFail("Title is incorrect: " + navBarTitle() + " instead of popular");
    }
}

function evalNonNilTitle() {
    target.delay(1);
    if(navBarTitle() != null && navBarTitle() != undefined) {
        UIALogger.logPass("Title is set for image details.");
    } else {
        UIALogger.logFail("Title is not set for image details.");
    }
}

function evalUpcomingTitle() {
    target.delay(1);
    if(navBarTitle() == "upcoming") {
        UIALogger.logPass("Title is upcoming");
    } else {
        UIALogger.logFail("Title is incorrect: " + navBarTitle() + " instead of upcoming");
    }
}

function evalEditorsTitle() {
    target.delay(1);
    if(navBarTitle() == "editors") {
        UIALogger.logPass("Title is editors");
    } else {
        UIALogger.logFail("Title is incorrect: " + navBarTitle() + " instead of editors");
    }
}

function evalImageDetails(){
    evalNonNilTitle();
    if(target.frontMostApp().mainWindow().images()["image"].isValid()) {
        UIALogger.logPass("Image is set.");
    } else {
        UIALogger.logFail("Image is not set.");
    }
    var value = target.frontMostApp().mainWindow().staticTexts()["name"].value();
    if(value != null && value != undefined) {
        UIALogger.logPass("Image name is set to " + value + ".");
    } else {
        UIALogger.logFail("Image name is not set.");
    }
    value = target.frontMostApp().mainWindow().staticTexts()["rating"].value();
    if(value != null && value != undefined) {
        UIALogger.logPass("Image rating is set to " + value + ".");
    } else {
        UIALogger.logFail("Image rating is not set.");
    }
}

function tapTableViewCell() {
    target.pushTimeout(60);
    target.frontMostApp().mainWindow().tableViews()[0].cells()["cell0"].tap();//navigate to image details
    target.popTimeout();
}

function tapButton(name) {
    if (name != null && name != undefined) {
        target.frontMostApp().mainWindow().buttons()[name].tap();
    }
}

function navigateBack() {
    target.frontMostApp().navigationBar().leftButton().tap();
}

function logWindowElements() {
    target.frontMostApp().mainWindow().logElementTree();
}

//500px
eval500pxTitle();
tapButton("popular");//navigate to POPULAR

//POPULAR
evalPopularTitle();
tapTableViewCell();

//IMAGE DETAILS
evalImageDetails();
navigateBack(); //navigate back to POPULAR

//POPULAR
evalPopularTitle();
navigateBack(); //navigate back to 500px

//500px
eval500pxTitle();
tapButton("upcoming");

//UPCOMING
evalUpcomingTitle();
tapTableViewCell();

//IMAGE DETAILS
evalImageDetails();
navigateBack();//navigate back to UPCOMING

//UPCOMING
evalUpcomingTitle();
navigateBack();

//500px
eval500pxTitle();
tapButton("editors");

//EDITORS
evalEditorsTitle();
tapTableViewCell();

//IMAGE DETAILS
evalImageDetails();
navigateBack();

//EDITORS
evalEditorsTitle();
navigateBack();

//500px
eval500pxTitle();
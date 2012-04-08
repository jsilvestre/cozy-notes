should = require("should")
client = require("./client")
DataTree = require("../lib/tree").Tree

responseTest = null
bodyTest = null


storeResponse = (error, response, body, done) ->
    responseTest = null
    bodyTest = null
    if error
        console.log error
        false.should.be.ok()
    else
        responseTest = response
        bodyTest = body
    done()


handleResponse = (error, response, body, done) ->
    if error
        console.log error
        false.should.be.ok()
    done()


describe "/tree", ->

    describe "POST /tree Create a note inside tree", ->
        it "When I send data for a node creation to /tree", (done) ->
            client.post "tree/", { path: "/all/recipe/dessert/brownie" }, (error, response, body) ->
                storeResponse error, response, body, done

        it "Then a 201 success response is returned", ->
            responseTest.statusCode.should.equal 201

    describe "GET /tree Retrieve current tree", ->

        it "When I retrieve tree from /tree", (done) ->
            client.get "tree/", (error, response, body) ->
                storeResponse error, response, body, done

        it "Then I have a tree that contains path /all/recipe/dessert/brownie", ->
            tree = new DataTree bodyTest
            should.exist tree.all.recipe.dessert.brownie

     describe "DELETE /tree Delte given node", ->

        it "When I delete node /all/recipe/dessert", (done) ->
            client.del "tree/", path: "/all/recipe/dessert", (error, response, body) ->
                storeResponse error, response, body, done

        it "Then a 200 success response is returned", ->
            responseTest.statusCode.should.equal 200

        it "When I retrieve tree from /tree", (done) ->
            client.get "tree/", (error, response, body) ->
                storeResponse error, response, body, done

        it "Then I have a tree that contains only path /all/recipe", ->
            tree = new DataTree bodyTest
            should.exist tree.all.recipe
            should.not.exist tree.all.recipe.dessert

    describe "PUT /tree Retrieve current", ->

        it "When I retrieve tree from /tree", (done) ->
            data =
                path: "/all/recipes"
                newName: "main dishes"
                
            client.put "tree/", data, (error, response, body) ->
                storeResponse error, response, body, done

        it "Then I have a tree that contains path /all/main-dishes", ->
            tree = new DataTree bodyTest
            should.exist tree.all.main_dishes


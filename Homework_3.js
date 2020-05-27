#--Query 1---#

db.Matches.aggregate(
    [   {$lookup: {
        from: 'Team', 
        localField: "home_team_api_id", 
        foreignField: "team_api_id",
        as: "home_team_info"}
     },
    {$lookup: {
        from: 'Team', 
        localField: "away_team_api_id", 
        foreignField: "team_api_id",
        as: "away_team_info"}
    },
    { $project: {_id:0,Home_team:{ $arrayElemAt: [ "$home_team_info.team_long_name", 0] },
                Away_team:{$arrayElemAt: [ "$away_team_info.team_long_name", 0] }
                ,total_goal : { $add: ["$home_team_goal", "$away_team_goal"]}}},
    { $sort: {total_goal:-1}
    }
])

#---Query 2---#

db.Matches.aggregate([
    {$match : {'country_id':10257}},
    {$lookup: {
        from: 'Team', 
        localField: "home_team_api_id", 
        foreignField: "team_api_id",
        as: "home_team_info"}
    },
    {$lookup: {
           from: "Player",
           localField: "home_player_1",
           foreignField: "player_api_id",
           as: "player_info"}
    },
    {$group:{ 
            _id: {team:{$arrayElemAt: ['$home_team_info.team_long_name',0]},goalkeeper:{$arrayElemAt:['$player_info.player_name',0]}},
            presenze : {$sum:1}
        }
    },
    {$sort:{'_id.team':1}}
    
])

#---Query 3---#

db.Matches.aggregate([
{   $match : {'season':'2008/2009' }},
    {$lookup: {
           from: "League",
           localField: "country_id",
           foreignField: "id",
           as: "League_name"
            }
    },
    {$group:{ 
            _id: {$arrayElemAt:['$League_name.name',0]},
            league_match : { $sum: 1 }}},
    {$sort:{league_match:-1}}]);
    
#---Map Reduce---#

var mapfunction = function() {emit (this.player_api_id,this.overall_rating)};

var reducefunction = function(key,values) {return Math.max.apply(Math, values)};

db.Player_attributes.mapReduce(
   mapfunction,
   reducefunction,
   { out: "map_reduce_example" }
);


var mapfunction2 = function() {
     var values = 1
     emit (this.value,values)};

var reducefunction2 = function(key,values) {return Array.sum(values)};

db.map_reduce_example.mapReduce(
   mapfunction2,
   reducefunction2,
   { out: "map_reduce_example2" }
);

db.map_reduce_example2.find().sort( { _id: 1 } );

#---Map Reduce 2---#

var mapfunction = function() {emit (this.home_team_api_id,this.home_player_11)};

var reducefunction = function(key,value) {return value.join()};

db.Matches.mapReduce(
   mapfunction,
   reducefunction,
   { out: "map_reduce_example3" }
);

db.map_reduce_example3.find().sort( { _id: 1 } );

db.map_reduce_example.aggregate([
  { $project : { Stricker : { $split: ["$value", ","] }}},
  { $project : { Stricker:{$divide:[
                        {$convert: {input:{$size: 
                                            {$filter:
                                    {   
                                        input: "$Stricker",
                                        as: "e",
                                        cond:{ $ne: ["$$e",'']}
                                    }
                                    
                                }
                                
                            },to:'int'},  
                        { $convert: { input:{$size:'$Stricker'}, to: "int" } }]}}}]);
                        
#---Map reduce 3---#

var mapfunction = function() {emit (this.home_team_api_id,this.home_player_11)};

var reducefunction = function(key,value) {return value.join()};

db.Matches.mapReduce(
   mapfunction,
   reducefunction,
   { out: "map_reduce_example4" }
);

db.map_reduce_example4.find().sort( { _id: 1 } );

db.map_reduce_example4.aggregate([
  { $project : { Stricker : { $split: ["$value", ","]}}},
   { "$addFields": {
   "distinct": { 
     "$size": { "$setDifference": [ '$Stricker', [] ] }
   } 
  }}])

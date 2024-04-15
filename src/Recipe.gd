class_name Recipe

static var ID_TO_IMG = {
	'egg': preload('res://assets/ehh/static/shelfG/egg.png'),
	'chicken': preload('res://assets/chikin.png'),
	'rose': preload('res://assets/ehh/static/shelfG/rose.png'),
	'diamond': preload('res://assets/ehh/static/shelfG/diamond.png'),
	'skull': preload('res://assets/ehh/static/shelfG/skull.png'),
	'eye': preload('res://assets/ehh/static/shelf2/eye.png'),
	'eyer': preload('res://assets/theyeyer.png'),
	'feather': preload('res://assets/feather.png'),
	'tooth': preload('res://assets/tooth.png'),
	'dust': preload('res://assets/dust.png'),
	'fairy': preload('res://assets/fairy.png'),
	'bigboy': preload('res://assets/bigboy.png'),
}

var result: PackedScene
var result_id: String
var items: Array[String] = []
var catalyst: Array[String] = []

static func GetList() -> Array[Recipe]:
    var arr: Array[Recipe] = []

    var r = Recipe.new()
    r.result = load('res://chikin.tscn')
    r.result_id = 'chicken'
    r.items.push_back('egg');
    r.catalyst.append_array(['rose'])
    arr.append(r)

    r = Recipe.new()
    r.result = load('res://eye.tscn')
    r.result_id = 'eye'
    r.items.append_array(['diamond', 'skull']);
    r.catalyst.append_array(['rose'])
    arr.append(r)

    r = Recipe.new()
    r.result = load('res://fairy.tscn')
    r.result_id = 'fairy'
    r.items.append_array(['feather', 'tooth']);
    r.catalyst.append_array(['rose', 'rose'])
    arr.append(r)
    
    r = Recipe.new()
    r.result = load('res://theeyer.tscn')
    r.result_id = 'eyer'
    r.items.append_array(['eye', 'skull', 'feather']);
    r.catalyst.append_array(['rose', 'feather'])
    arr.append(r)

    r = Recipe.new()
    r.result = load('res://bigboy.tscn')
    r.result_id = 'bigboy'
    r.items.append_array(['diamond', 'eye', 'skull', 'diamond', 'rose', 'egg']);
    r.catalyst.append_array(['feather', 'dust'])
    arr.append(r)
    

    return arr


package normal
{
	import flash.media.Sound;
	
	import org.flixel.FlxSprite;
	
	public class GameState
	{
		private static var singleton : GameState;
		
		[Embed('img/car-1.png')]	private var car1Image : Class;
		[Embed('img/car-2.png')]	private var car2Image : Class;
		[Embed('img/car-3.png')]	private var car3Image : Class;
		[Embed('img/car-4.png')]	private var car4Image : Class;
		[Embed('img/car-5.png')]	private var car5Image : Class;
		
		private var carImageArray : Array = [car1Image, car2Image, car3Image, car4Image, car5Image];
		
		[Embed('snd/mp3/everything-is-normal96K.mp3')]	private var everythingNormalSound : Class;
		[Embed('snd/mp3/explosion96K.mp3')]	private var explosionSound : Class;
		[Embed('snd/mp3/gas96K.mp3')]	private var gasSound : Class;
		[Embed('snd/mp3/new-riot96K.mp3')]	private var newRiotSound : Class;
		[Embed('snd/mp3/normal-196K.mp3')]	private var normal1Sound : Class;
		[Embed('snd/mp3/normal-296K.mp3')]	private var normal2Sound : Class;
		[Embed('snd/mp3/normal-396K.mp3')]	private var normal3Sound : Class;
		[Embed('snd/mp3/normal-496K.mp3')]	private var normal4Sound : Class;
		[Embed('snd/mp3/normal-596K.mp3')]	private var normal5Sound : Class;
		[Embed('snd/mp3/normal-696K.mp3')]	private var normal6Sound : Class;
		[Embed('snd/mp3/normal-796K.mp3')]	private var normal7Sound : Class;
		[Embed('snd/mp3/normal-896K.mp3')]	private var normal8Sound : Class;
		[Embed('snd/mp3/normal-996K.mp3')]	private var normal9Sound : Class;
		[Embed('snd/mp3/normal-1096K.mp3')]	private var normal10Sound : Class;
		[Embed('snd/mp3/scream96K.mp3')]	private var screamSound : Class;
		[Embed('snd/mp3/siren96K.mp3')]	private var sirenSound : Class;
		
		private var normalSoundArray : Array = [normal1Sound, normal2Sound, normal3Sound, 
		                                        normal4Sound, normal5Sound, normal6Sound,
		                                        normal7Sound, normal8Sound, normal9Sound, normal10Sound];
		
		public var state : PlayState;
		
		public static function getInstance() : GameState {
			if (!singleton) {
				singleton = new GameState();
			}
			return singleton;
		}
		
		public function GameState()
		{
			start();
		}
		
		public function start() : void {
			timeCode = 0;
			cars = new Array();
			persons = new Array();
			fires = new Array();
			nextTimeForCar = -1;
			nextTimeForPerson = -1;
			normalness = 0;
			minNormalness = 0;
			level = 0;
			currentMaxTimeForPerson = TIME_TO_CREATE_PERSON;
			kills = 0;
			health = 100;
			gameOver = false;
			currentNormalnessDecrease = NORMALNESS_DECREASE_TIME;
			generateCars();
		}
		
		public function update() : void {
			timeCode++;
			timeCode %= 100000;
			
			generatePerson();
			filterPersons();
			generateCar();
			
			if (currentNormalnessDecrease == 0) {
				currentNormalnessDecrease = NORMALNESS_DECREASE_TIME;
				normalness = Math.max(minNormalness, normalness-NORMALNESS_DECREASE_AMOUNT);
			} else {
				currentNormalnessDecrease--;
			}
			
			if (normalness == MAX_NORMALNESS) {
				health--;
				
				if (health == 0) {
					gameOver = true;
					return;
				}
			}
			
			if ((timeCode+17) % TIME_TO_PUT_RIOT == 0) updatePersons();
			if (timeCode % TIME_TO_MOVE_CARS == 0) updateCars();
			
			if (timeCode % TIME_TO_PUT_SOUND == 0) makeSound();
		}
		
		public function generatePerson() : void {
			if (nextTimeForPerson == -1) {
				nextTimeForPerson = currentMaxTimeForPerson + (Math.floor(currentMaxTimeForPerson*Math.random())-(currentMaxTimeForPerson/4));
			} else if (nextTimeForPerson > 0) {
				nextTimeForPerson--;
			} else {
				nextTimeForPerson = -1;
				
				var startX : int = Math.floor(Math.random()*(MAP_WIDTH-3));
				var startY : int = COTA_MIL + Math.floor(Math.random()*(MAP_HEIGHT - COTA_MIL-3));
				var n : int = Math.ceil(Math.random()*4);
				
				var person : Riot = new Riot(startX, startY, Math.ceil(Math.random()*Riot.MAX_PERSONS), getAggresiveness()); //
				person.state = this; 
				persons.push(person);
				
				var snd : Sound = new newRiotSound();
				snd.play();
				
				state.personLayer.add(person);
			}
		}
		
		private function getAggresiveness() : int {
			var n : Number = Math.random()*100;
			
			if (n < 5) {
				return 5;
			} else if (n < 25) {
				return 3;
			} else if (n < 45) {
				return 2;
			} else if (n < 65) {
				return 1;
			} else if (n < 85) {
				return 0;
			} else {
				return -1;
			}
		}
		
		public function filterPersons() : void {
			persons = persons.filter(function (i:*, n:int, a:Array) : Boolean { return i.exists; });
		}
		
		public function updatePersons() : void {
			var aggresivePersons : Array = persons.filter(function (i:*, n:int, a:Array) : Boolean { return i.aggresiveness > 0; });
			if (aggresivePersons.length == 0) return;
			
			var n : int = Math.floor(Math.random()*aggresivePersons.length);
			
			if (aggresivePersons[n].makeRiot()) {
				generateFire(aggresivePersons[n].x, aggresivePersons[n].y);
				raiseMinNormalness(10);
			}
		}
		
		public function generateCars() : void {
			var start_n : int = Math.ceil(Math.random()*6);
			for (var i : int = 0; i != start_n; i++) {
				var dir : int = Math.random() < 0.5? -CAR_SPEED: CAR_SPEED;
				var startX : int = Math.ceil(Math.random() * MAP_WIDTH);
				var startY : int = 0;
				var n : int = Math.ceil(Math.random()*carImageArray.length);
				
				if (dir == 1) {
					if (startX <= 21) startY = 17; else startY = 18;
				} else {
					if (startX <= 21) startY = 16; else startY = 17;
				}
				
				cars.push(new Car(startX, startY, this["car"+n+"Image"], dir, 0));
			}
		}
		
		private function generateCar() : void {
			if (nextTimeForCar == -1) {
				nextTimeForCar = TIME_TO_CREATE_CAR + (Math.floor(TIME_TO_CREATE_CAR*Math.random())-(TIME_TO_CREATE_CAR/2));
			} else if (nextTimeForCar > 0) {
				nextTimeForCar--;
			} else {
				nextTimeForCar = -1;
				
				var dir : int = Math.random() < 0.5? -CAR_SPEED: CAR_SPEED;
				var startX : int = (dir == -1? 50: -3);
				var startY : int = 17;
				var n : int = Math.ceil(Math.random()*carImageArray.length);
				
				var car : Car = new Car(startX, startY, this["car"+n+"Image"], dir, 0) 
				cars.push(car);
				if (dir > 0){
					state.freeway2Layer.add(car);
				} else {
					state.freeway1Layer.add(car);
				}
			}
		}
		
		public function updateCars() : void {
			cars = cars.filter(function (i:*, n:int, a:Array) : Boolean { return i.exists; });
		}
		
		public function makeSound() : void {
			var sndClass : Class = normalSoundArray[Math.floor(Math.random()*normalSoundArray.length)];
			var snd : Sound = new sndClass();
			snd.play();
		}
		
		public function generateFire(x:int, y:int) : void {
			var f : Fire = new Fire(x, y-2);
			state.fireLayer.add(f);
			fires.push(f);
		}
		
		public function fire(cursorSprite:FlxSprite) : void {
			for (var i : int = 0; i != persons.length; i++) {
				var p : Riot = persons[i];
				var snd : Sound;
				
				if (p.collide(cursorSprite)) {
					
					if (p.aggresiveness == 0) {
						raiseNormalness(150);
					} else {
						raiseNormalness(50);
					}
			
					p.kill();
					if (Math.random() < 0.5) {
						snd = new gasSound();
					} else {
						snd = new screamSound();
					}
					snd.play();
					
					kills++;
					
					if (kills%(7+1*level) == 0) {
						snd = new sirenSound();
						snd.play(0, 2);
						currentMaxTimeForPerson = Math.max(Math.round(currentMaxTimeForPerson*0.8), 50);
						
					}
				}
			}
		}
		
		public function raiseNormalness(n:int) : void {
			normalness = Math.min(MAX_NORMALNESS, normalness+n);
		}
		
		public function raiseMinNormalness(n:int) : void {
			minNormalness = Math.min(MAX_NORMALNESS-60, minNormalness+n);
		}
		
		public const MAP_WIDTH : int = 50;
		public const MAP_HEIGHT : int = 20;
		public const COTA_MIL : int = 8;
		
		public const CAR_SPEED : int = 6;
		public const TIME_TO_MOVE_CARS : int = 10;
		public const TIME_TO_CREATE_CAR : int = TIME_TO_MOVE_CARS*25;
		
		public const TIME_TO_CREATE_PERSON : int = 400;
		
		public const TIME_TO_PUT_SOUND : int = 80;
		
		public const TIME_TO_PUT_RIOT : int = 400;
		
		
		public const MAX_NORMALNESS : int = 500;
		public const NORMALNESS_DECREASE_TIME : int = 50;
		public const NORMALNESS_DECREASE_AMOUNT : int = 5;
		
		public var timeCode : Number;
		
		public var currentMaxTimeForPerson : Number;
		public var nextTimeForPerson : Number;
		public var persons : Array;
		
		public var nextTimeForCar : Number;
		public var cars : Array;
		
		public var fires : Array;
		
		public var normalness : int;
		public var minNormalness : int;
		public var health : int;
		public var gameOver : Boolean;
		public var currentNormalnessDecrease : int;
		
		public var kills : int;
		public var level : int;
	}}
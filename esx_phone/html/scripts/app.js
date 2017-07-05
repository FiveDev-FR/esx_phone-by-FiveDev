//--            _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
//--   <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
//--(`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
//--(OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
//-- / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
//-- \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
//--  `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
//--   `--'    `--'       `-'     `------' `------'  `------'    `-'    
$( document ).ready( function() {
	
	let menu                = [];
	let currentItem         = 0;
	let currentVal          = null;
	let isMessageEditorOpen = false;
	let isMessagesOpen      = false;
	let isPhoneShowed       = false;
	let isAddContactOpen	= false;
	
	let consoleLog = function(txt) {
		$('#console').append(txt + '<br />');
		var console = document.getElementById('console')
		console.scrollTop = console.scrollHeight;
	}
	
	//	PHONE MENU ITEMS
	$('.phone-icon').click(function(event) {
		switch($(event.currentTarget).attr('id')) {
			case 'phone-icon-rep' :
				showRepertoire();
			break;
			case 'phone-icon-msg' :
				showMessages();
			break;
			case 'phone-icon-cop' :
				showNewMessage('police', 'Police');
			break;
			case 'phone-icon-ambu' :
				showNewMessage('ambulance', 'Ambulance');
			break;
			case 'phone-icon-taxi' :
				showNewMessage('taxi', 'Taxi');
			break;
			case 'phone-icon-depa' :
				showNewMessage('depanneur', 'Dépanneur');
			break;
		}
	});
	
	let showMain = function() {
		$('.screen').removeClass('active');
	}
	
	let showRepertoire = function() {
		$('#repertoire').addClass('active');
	}
	
	let hideRepertoire = function() {
		$('#repertoire').removeClass('active');
	}
	
	let showMessages = function(){	
		$('#messages').addClass('active');
		isMessagesOpen = true;
	}

	let hideMessages = function(){		
		$('#messages').removeClass('active');
		isMessagesOpen = false;
	}
	
	let showAddContact = function() {
		$('#contact').addClass('active');
	}
	
	let hideAddContact = function() {
		$('#contact').removeClass('active');
		$('#contact_name').val('');
		$('#contact_number').val('');
	}
	
	let showNewMessage = function(cnum, cname) {
		$('#writer').addClass('active');
		$('#writer_number').val(cnum);
		$('#writer .header-title').html(cname);
	}

	let hideNewMessage = function() {		
		$('#writer').removeClass('active');
		$('#writer_number').val('');
		$('#writer_message').val('');
		$('#writer .header-title').html('');
	}
	
	let showGPS = function(xPos, yPos) {
		$.post('http://esx_phone/setGPS', JSON.stringify({
			x: parseFloat(xPos),
			y: parseFloat(yPos)
		}
		));
	}
	
	//	ACTIONS BTNS
	$('#btn-head-back-msg').click(function() {
		hideNewMessage();
		hideMessages();
	});
	
	$('#btn-head-back-rep').click(function() {
		hideRepertoire();
	});
	
	$('#btn-head-back-writer, #writer_cancel').click(function() {
		hideNewMessage();
	});
	
	$('#btn-head-back-contact, #contact_cancel').click(function() {
		hideAddContact();
	});
	
	$('#btn-head-new-message').click(function() {
		showNewMessage('', 'Nouveau message');
	});
	
	$('#btn-head-new-contact').click(function() {
		showAddContact();
	});
	
	let ContactTpl = '<div class="contact {{online}}">' +
							'<div class="sender-info">' +
								'<div class="center">' +
									'<span class="sender">{{sender}}</span><br /><span class="phone-number">#{{phoneNumber}}</span>' +
								'</div>' +
							'</div>' +
							'<div class="actions"><span class="new-msg newMsg-btn" data-contact-number="{{phoneNumberData}}" data-contact-name="{{senderData}}"></span></div>' +
						'</div>';
	
	let MessageTpl = '<div class="message">' +
						'<div class="sender-info">' +
							'<div class="center">' +
								'<span class="sender">{{sender}}</span><br/><span class="phone-number">#{{phoneNumber}}</span>' +
							'</div>' + 
						'</div>' + 
						'<div class="body">{{message}}</div>' + 
						'<div class="actions"><span class="new-msg {{anonyme}} reply-btn" data-contact-number="{{phoneNumberData}}" data-contact-name="{{senderData}}"></span><span class="gps {{activeGPS}} gps-btn" data-gpsX="{{gpsLocationX}}" data-gpsY="{{gpsLocationY}}"></span><span class="ok-btn {{showOK}}" data-contact-number="{{okNumberData}}" data-contact-job="{{jobData}}"></span></div>' +
					'</div>';

	let contacts = [];
	
	let writer = {
		phoneNumber: null,
		type       : null
	}

	let renderContacts = function(){
		
		let contactView = '';
		let itemView = '';
		
		if(contacts.length >  0) {
			for(let i=0; i<contacts.length; i++) {
				itemView = ContactTpl;
				itemView = itemView.replace("{{phoneNumber}}", contacts[i].value);
				itemView = itemView.replace("{{sender}}", contacts[i].label);
				itemView = itemView.replace("{{phoneNumberData}}", contacts[i].value);
				itemView = itemView.replace("{{senderData}}", contacts[i].label);
				if(contacts[i].online) {
					itemView = itemView.replace("{{online}}", 'online');
				} else {
					itemView = itemView.replace("{{online}}", '');
				}
				if(contacts[i].anonyme) {
					itemView = itemView.replace("{{anonyme}}", 'online');
				} else {
					itemView = itemView.replace("{{anonyme}}", '');
				}
				contactView += itemView;
			}
		} else {
			contactView = '<div class="contact no-item online"><p class="no-item">Aucun contact</p></div>';
		}
		
		$('#phone #repertoire .repertoire-list').html(contactView);
	
		$('.contact.online .new-msg').click(function() {
			showNewMessage($(this).attr('data-contact-number'), $(this).attr('data-contact-name'));
		});
		
	}
	
	$('.contact.online .new-msg').click(function() {
		showNewMessage($(this).attr('data-contact-number'));
	});

	let reloadPhone = function(phoneData){

		contacts = [];

		for(let i=0; i<phoneData.contacts.length; i++){
			contacts.push({
				label: phoneData.contacts[i].name,
				value: phoneData.contacts[i].number,
				online: phoneData.contacts[i].online
			})
		}

		renderContacts();

		$('#phone-number').text('#' + phoneData.phoneNumber);
	}

	let showPhone = function(phoneData){
		reloadPhone(phoneData);
		
		$('#phone').show();
		$("#cursor").show();
		isPhoneShowed = true;
	}

	let hidePhone = function(){		
		$('#phone').hide();
		$("#cursor").hide();
		isPhoneShowed = false;
	}
	
	let messages = [];

	let addMessage = function(phoneNumber, pmessage, pposition, pactions, panonyme, pjob){
		let messageView = '';
		let itemView = '';
		
		messages.push({
			value: phoneNumber,
			message: pmessage,
			position: pposition,
			actions: pactions,
			anonyme: panonyme,
			job: pjob
		})
		
		if(messages.length >  0) {
			for(let i=0; i<messages.length; i++) {
				itemView = MessageTpl;
				let fromName = "Inconnu";
				let fromNumber = messages[i].value;
				if(messages[i].job != "player") {
					fromName = messages[i].job;
				}
				if(messages[i].anonyme) {
					if(messages[i].job == "player") {
						fromName = "Anonyme";
					}
					fromNumber = "Anonyme";
					itemView = itemView.replace("{{anonyme}}", "anonyme");
				} else {
					for(let j=0; j<contacts.length; j++) {
						if(contacts[j].value == messages[i].value) {
							if(messages[i].job == "player") {
								fromName = contacts[j].label;
							}
						}
					}
					itemView = itemView.replace("{{anonyme}}", "");
				}
				itemView = itemView.replace("{{phoneNumber}}", fromNumber);
				itemView = itemView.replace("{{sender}}", fromName);
				itemView = itemView.replace("{{message}}", messages[i].message);
				itemView = itemView.replace("{{phoneNumberData}}", fromNumber);
				itemView = itemView.replace("{{senderData}}", fromName);
				itemView = itemView.replace("{{okNumberData}}", fromNumber);
				if(messages[i].job != "player") {
					itemView = itemView.replace("{{gpsLocationX}}", messages[i].position.x);
					itemView = itemView.replace("{{gpsLocationY}}", messages[i].position.y);
					itemView = itemView.replace("{{activeGPS}}", "active");
					itemView = itemView.replace("{{jobData}}", messages[i].job);
					itemView = itemView.replace("{{showOK}}", "showOK");
				} else {
					itemView = itemView.replace("{{gpsLocationX}}", '');
					itemView = itemView.replace("{{gpsLocationY}}", '');
					itemView = itemView.replace("{{activeGPS}}", '');
					itemView = itemView.replace("{{jobData}}", '');
					itemView = itemView.replace("{{showOK}}", '');
				}
				
				messageView = itemView + messageView;
			}
		} else {
			messageView = '<div class="message no-item"><p class="no-item">Aucun messages</p></div>';
		}
		
		$('#phone #messages .messages-list').html(messageView);
		
		$('.message .new-msg').click(function() {
			showNewMessage($(this).attr('data-contact-number'), $(this).attr('data-contact-name'));
		});
		
		$('.message .gps').click(function() {
			showGPS($(this).attr($(this).attr('data-gpsX')), $(this).attr($(this).attr('data-gpsY')));
		});
		
		$('.message .ok-btn').click(function() {
			$.post('http://esx_phone/send', JSON.stringify({
				message: $(this).attr($(this).attr('data-contact-job')) + ": Bien reçu !",
				number: $(this).attr($(this).attr('data-contact-number')),
				anonyme: false
			}))
		});
	}
	
	//  CURSOR
	var documentWidth  = document.documentElement.clientWidth;
	var documentHeight = document.documentElement.clientHeight;

	var cursorX = documentWidth  / 2;
	var cursorY = documentHeight / 2;

	let UpdateCursorPos = function() {
		$("#cursor").css('left', cursorX + 'px');
		$("#cursor").css('top', cursorY + 'px');
	}

	$(document).mousemove(function(event) {
		cursorX = event.pageX + 1;
		cursorY = event.pageY + 1;
		UpdateCursorPos();
	});

	function scrollMessages(direction){
		

		let element = $('#messages .container')[0];

		if(direction == 'UP')
			element.scrollTop -= 100;

		if(direction == 'DOWN')
			element.scrollTop += 100;

	}

	$('#writer_send').click(function(){
		let phoneNumber
		if(typeof $('#writer_number').val() == 'number') {
			phoneNumber = parseInt($('#writer_number').val());
		} else if (typeof $('#writer_number').val() == 'string') {
			phoneNumber = $('#writer_number').val();
		}
		$.post('http://esx_phone/send', JSON.stringify({
			message: $('#writer_message').val(),
			number: phoneNumber,
			anonyme: $('#writer_anonyme').is(':checked')
		}))
	});

	$('#contact_send').click(function(){
		$.post('http://esx_phone/add_contact', JSON.stringify({
			contactName: $('#contact_name').val(),
			phoneNumber: $('#contact_number').val()
		}))
	});

	window.onData = function(data){

		if(data.scroll === true){
			if(isMessagesOpen)
				scrollMessages(data.direction);
		}

		if(data.reloadPhone === true){
			reloadPhone(data.phoneData);
		}

		if(data.showPhone === true){
			showPhone(data.phoneData);
		}

		if(data.showPhone === false){
			hidePhone();
		}

		if(data.showMessageEditor === false){
			hideNewMessage();
		}

		if(data.newMessage === true){
			addMessage(data.phoneNumber, data.message, data.position, data.actions, data.anonyme, data.job);
		}

		if(data.contactAdded === true){
			reloadPhone(data.phoneData);
			hideAddContact();
		}

		if(data.move && isPhoneShowed){

			if(data.move == 'UP'){
				scroll('UP');
			}

			if(data.move == 'DOWN'){
				scroll('DOWN');
			}
		}

		if(data.enterPressed){

			if(isPhoneShowed) {

				$.post('http://esx_phone/select', JSON.stringify({
					val  : currentVal
				}));

			}

		}

	}

	window.onload = function(e){ window.addEventListener('message', function(event){ onData(event.data) }); }

	document.onkeydown = function (data) {
		if ((data.which == 120 || data.which == 27) && isPhoneShowed) { // || data.which == 8
			$.post('http://esx_phone/escape');
		}
	};
});

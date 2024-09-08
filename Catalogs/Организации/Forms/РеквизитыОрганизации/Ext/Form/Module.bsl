﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	
	НастройкиПечатиРеквизитовОрганизации = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"Справочник.Организации",
		"НастройкиПечатиРеквизитовОрганизации" + Строка(Организация));
	Если НастройкиПечатиРеквизитовОрганизации <> Неопределено Тогда
		ОсновнойБанковскийСчет = НастройкиПечатиРеквизитовОрганизации.ОсновнойБанковскийСчет;;
	Иначе
		ОсновнойБанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация);
	КонецЕсли;

	Результат = СформироватьРеквизитыОрганизации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОсновнойБанковскийСчетПриИзменении(Элемент)
	Результат = СформироватьРеквизитыОрганизации();     
	СохранитьНастройкиПечатиРеквизитов();
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	ПоказатьДиалогОтправкиПоПочте();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьРеквизитыОрганизации()
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации.РеквизитыОрганизации");
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;	
	
	ЮЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	ФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	Если ОсновнойБанковскийСчет.Пустая() Тогда
		ОсновнойБанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация);
	КонецЕсли;
	
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(
		Организация, ОбщегоНазначения.ТекущаяДатаПользователя(),,ОсновнойБанковскийСчет);
		
	НаименованиеТабличногоДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Реквизиты организации %1'"), СведенияОбОрганизации.СокращенноеНаименование);
	Разделитель = Макет.ПолучитьОбласть("Разделитель");
	
	НаименованияНаДату = ОрганизацииПовтИсп.НаименованияНаДату(Организация, ТекущаяДатаСеанса());

	Область = Макет.ПолучитьОбласть("Наименование");
	Область.Параметры.НаименованиеДляПечатныхФорм = НаименованияНаДату.НаименованиеПолное;
	ТабличныйДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("ИНН");
	Область.Параметры.ИНН = СведенияОбОрганизации.ИНН;
	ТабличныйДокумент.Вывести(Область);
	
	Если ЮЛ Тогда
		Область = Макет.ПолучитьОбласть("КПП");
		Область.Параметры.КПП = СведенияОбОрганизации.КПП;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ЮЛ И ЗначениеЗаполнено(СведенияОбОрганизации.ОГРН) Тогда
		Область = Макет.ПолучитьОбласть("ОГРН");
		Область.Параметры.ОГРН = СведенияОбОрганизации.ОГРН;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ФЛ И ЗначениеЗаполнено(СведенияОбОрганизации.ОГРН) Тогда
		Область = Макет.ПолучитьОбласть("ОГРНИП");
		Область.Параметры.ОГРНИП = СведенияОбОрганизации.ОГРН;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СведенияОбОрганизации.КодПоОКПО) Тогда
		Область = Макет.ПолучитьОбласть("ОКПО");
		Область.Параметры.КодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ФЛ И ЗначениеЗаполнено(СведенияОбОрганизации.Свидетельство) Тогда
		Область = Макет.ПолучитьОбласть("Свидетельство");
		Область.Параметры.СвидетельствоСерияНомерДатаВыдачи = СтрЗаменить(СведенияОбОрганизации.Свидетельство, "Свидетельство", "№");
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СведенияОбОрганизации.НомерСчета) 
		И ЗначениеЗаполнено(СведенияОбОрганизации.БИК) 
		И ЗначениеЗаполнено(СведенияОбОрганизации.КоррСчет) 
		И ЗначениеЗаполнено(СведенияОбОрганизации.Банк) Тогда
		Область = Макет.ПолучитьОбласть("РасчетныйСчет");
		Область.Параметры.НомерСчета = СведенияОбОрганизации.НомерСчета;
		Область.Параметры.БИК = СведенияОбОрганизации.БИК;
		Область.Параметры.КоррСчет = СведенияОбОрганизации.КоррСчет;
		Область.Параметры.Банк = СведенияОбОрганизации.Банк;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(Разделитель);
	
	Если ЮЛ Тогда
		Область = Макет.ПолучитьОбласть("ЮридическийАдрес");
		Область.Параметры.ЮридическийАдрес = СведенияОбОрганизации.ЮридическийАдрес;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
		
	Если ЮЛ И ЗначениеЗаполнено(СведенияОбОрганизации.ФактическийАдрес) Тогда
		Область = Макет.ПолучитьОбласть("ФактическийАдрес");
		Область.Параметры.ФактическийАдрес = СведенияОбОрганизации.ФактическийАдрес;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;

	Если ФЛ Тогда
		Область = Макет.ПолучитьОбласть("АдресИП");
		Область.Параметры.АдресИП = СведенияОбОрганизации.ЮридическийАдрес;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(СведенияОбОрганизации.Телефоны) Тогда
		Область = Макет.ПолучитьОбласть("Телефон");
		Область.Параметры.Телефон = СведенияОбОрганизации.Телефоны;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СведенияОбОрганизации.ЭлектроннаяПочта) Тогда
		Область = Макет.ПолучитьОбласть("ЭлектроннаяПочта");
		Область.Параметры.ЭлектроннаяПочта = СведенияОбОрганизации.ЭлектроннаяПочта;
		ТабличныйДокумент.Вывести(Область);
	КонецЕсли;

	Если ЮЛ Тогда
		
		ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Организация);
		ДолжностьРуководителя = ОтветственныеЛица.РуководительДолжность;
		ФИОРуководителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтветственныеЛица.Руководитель, "Наименование");

		Если ЗначениеЗаполнено(ДолжностьРуководителя) И ЗначениеЗаполнено(ФИОРуководителя) Тогда
			Область = Макет.ПолучитьОбласть("Руководитель");
			Область.Параметры.ДолжностьРуководителя = ДолжностьРуководителя;
			Область.Параметры.ФИОРуководителя = ФИОРуководителя;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбъектыПечати = Новый СписокЗначений;
	ОбъектыПечати.Добавить(Организация);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Организация);

	ТабличныйДокумент.ПолеСверху = 20;
	ТабличныйДокумент.ПолеСнизу = 20;
	ТабличныйДокумент.ПолеСлева = 20;
	ТабличныйДокумент.ПолеСправа = 20;
	
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Организация_КарточкаОрганизации";
	
	Возврат ТабличныйДокумент;

КонецФункции

&НаСервере
Процедура СохранитьНастройкиПечатиРеквизитов()
	Если ЗначениеЗаполнено(ОсновнойБанковскийСчет) Тогда 
		НастройкиПечатиРеквизитовОрганизации = Новый Структура("ОсновнойБанковскийСчет", ОсновнойБанковскийСчет);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"Справочник.Организации",
			"НастройкиПечатиРеквизитовОрганизации" + Строка(Организация),
			НастройкиПечатиРеквизитовОрганизации);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоПочте()
	Вложение = Новый Структура;
	Вложение.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор));
	Вложение.Вставить("Представление", НаименованиеТабличногоДокумента);
	
	СписокВложений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Вложение);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		ПараметрыОтправки = МодульРаботаСПочтовымиСообщениямиКлиент.ПараметрыОтправкиПисьма();
		ПараметрыОтправки.Тема = НаименованиеТабличногоДокумента;
		ПараметрыОтправки.Вложения = СписокВложений;
		МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
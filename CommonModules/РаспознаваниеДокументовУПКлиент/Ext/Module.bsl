﻿#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

Процедура ОткрытиеФормыСоздаваемогоДокумента(ТипДокумента, ПараметрыЗаполнения, Владелец) Экспорт
		
	Если ТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
		ИмяФормыСФ = "Документ.СчетФактураВыданный.Форма.ФормаДокумента";
	Иначе
		ИмяФормыСФ = "Документ.СчетФактураПолученный.Форма.ФормаДокумента";
	КонецЕсли;
	
	ПараметрыОткрытия =  ПараметрыЗаполнения;	
	ОткрытьФорму(ИмяФормыСФ, ПараметрыОткрытия, Владелец, , , , ,);

	//ПараметрыОбработчика = Новый Структура;
	//ПараметрыОбработчика.Вставить("ТипДокумента", ТипДокумента);
	//ПараметрыОбработчика.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
	//ПараметрыОбработчика.Вставить("Владелец", Владелец);
	//
	//Оповещение = Новый ОписаниеОповещения("ПослеВыбораЗначения", ЭтотОбъект, ПараметрыОбработчика);
	//
	//Заголовок = НСтр("ru = 'Выберите вид документа'");
	//
	//Если ТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
	//	НаРеализацию = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации. НаРеализацию");
	//	ПоказатьВводЗначения(Оповещение, НаРеализацию, Заголовок);
	//ИначеЕсли ТипДокумента = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
	//	НаПоступление = ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыПолученного.НаПоступление");
	//	ПоказатьВводЗначения(Оповещение, НаПоступление, Заголовок);
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеВыбораЗначения(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипДокумента = ДополнительныеПараметры.ТипДокумента;
	ПараметрыЗаполнения = ДополнительныеПараметры.ПараметрыЗаполнения;
	Владелец = ДополнительныеПараметры.Владелец;
	
	Если ТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		
		ПараметрыЗаполнения.Вставить("ВидСчетаФактуры", ВыбранноеЗначение);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ПараметрыЗаполнения);
		
		Если ТипДокумента = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
			ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаДокумента";
		Иначе
			ИмяФормы = "Документ.СчетФактураПолученный.Форма.ФормаДокумента";
		КонецЕсли;
		
		ОткрытьФорму(ИмяФормы, ПараметрыФормы, Владелец, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
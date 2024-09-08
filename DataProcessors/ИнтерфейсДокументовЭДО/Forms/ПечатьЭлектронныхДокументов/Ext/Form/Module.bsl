﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ЭлектронныеДокументы") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ЭлектронныеДокументы) = Тип("Массив") Тогда
		ЭлектронныеДокументы.ЗагрузитьЗначения(Параметры.ЭлектронныеДокументы);
	ИначеЕсли ТипЗнч(Параметры.ЭлектронныеДокументы) = Тип("СписокЗначений") Тогда
		ЭлектронныеДокументы = Параметры.ЭлектронныеДокументы;
	Иначе
		ЭлектронныеДокументы.Добавить(Параметры.ЭлектронныеДокументы);
	КонецЕсли;
	
	ВыводитьШтампыПодписей = Истина;
		
	Если ЭлектронныеДокументы.Количество() = 1 Тогда
		
		Элементы.НадписьЭлектронныеДокументы.Заголовок = НСтр("ru = 'Документ'");
		
		ЭлектронныйДокумент = ЭлектронныеДокументы[0].Значение;
		ТекстГиперссылки = ЭлектронныеДокументыЭДО.ПредставлениеДокумента(ЭлектронныйДокумент);
		
	Иначе
		
		Элементы.НадписьЭлектронныеДокументы.Заголовок = НСтр("ru = 'Документы'");
		
		ТекстГиперссылки = СтрШаблон(НСтр("ru = 'Список (%1)'"), ЭлектронныеДокументы.Количество());
		
	КонецЕсли;	
	
	ТекстГиперссылки = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ТекстГиперссылки);
	НадписьЭлектронныеДокументы = ТекстГиперссылки;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПечататьЭлектронныйДокумент = Истина;
	ПечататьРеестрЭлектронныхДокументов = ЭлектронныеДокументы.Количество() > 1;
	
	ПараметрыСтрокой = "ПечататьЭлектронныйДокумент,ПечататьТехнологическиеКвитанции,"
		+ "ПечататьКарточкуЭлектронногоДокумента,ПечататьРеестрЭлектронныхДокументов,ВыводитьШтампыПодписей,"
		+ "ВыводитьДопДанные,ВыводитьБанковскиеРеквизиты,ВыводитьКопияВерна";
	Для каждого ИмяПараметра Из СтрРазделить(ПараметрыСтрокой, ",") Цикл
		Если Параметры.Свойство(ИмяПараметра) Тогда
			ЭтотОбъект[ИмяПараметра] = Параметры[ИмяПараметра];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьЭлектронныеДокументыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭлектронныеДокументы.Количество() > 1 Тогда
		ПараметрыФормы = Новый Структура("Документообороты", ЭлектронныеДокументы.ВыгрузитьЗначения());
		ОткрытьФорму("Обработка.ИнтерфейсДокументовЭДО.Форма.СписокВыгружаемыхЭлектронныхДокументов", ПараметрыФормы, ЭтотОбъект);
	Иначе
		ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокумент(ЭлектронныеДокументы[0].Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Если Не ПечататьЭлектронныйДокумент
		И Не ПечататьКарточкуЭлектронногоДокумента
		И Не ПечататьТехнологическиеКвитанции
		И Не ПечататьРеестрЭлектронныхДокументов Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран состав печати'"));
		Возврат;
	КонецЕсли;
	
	ПечатныеФормы = СформироватьПечатныеФормы();
	Если ПечатныеФормы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не сформировано печатных форм для данного состава'"));
		Возврат;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	Для каждого ПечатнаяФорма Из ПечатныеФормы Цикл
		Идентификаторы.Добавить(ПечатнаяФорма.ИмяМакета);		
	КонецЦикла;
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(Идентификаторы);
	
	Для каждого ПечатнаяФорма Из ПечатныеФормы Цикл
		ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ПечатнаяФорма.ИмяМакета); 
		ОписаниеПечатнойФормы.ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
		ОписаниеПечатнойФормы.СинонимМакета = ПечатнаяФорма.СинонимМакета;
	КонецЦикла;
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьПечатныеФормы()
	
	МассивЭлектронныхДокументов = ЭлектронныеДокументы.ВыгрузитьЗначения();
	
	ПараметрыСоставаПечати = ИнтерфейсДокументовЭДО.ПараметрыСоставаПечатиЭлектронныхДокументов();
	ЗаполнитьЗначенияСвойств(ПараметрыСоставаПечати, ЭтотОбъект);
	ПараметрыСоставаПечати.ПечататьКарточкуЕслиНеУдалосьНапечататьЭлектронныйДокумент = Истина;
	ПараметрыСоставаПечати.ДополнятьСинонимМакетаВидомПечатнойФормы = Истина;
	
	ПараметрыВизуализации = ИнтерфейсДокументовЭДО.НовыеПараметрыВизуализацииДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыВизуализации, ЭтотОбъект);
	
	ПечатныеФормы = ИнтерфейсДокументовЭДО.СформироватьПечатныеФормыЭлектронныхДокументов(МассивЭлектронныхДокументов,
		ПараметрыСоставаПечати, ПараметрыВизуализации);
	
	Возврат ПечатныеФормы;
	
КонецФункции

#КонецОбласти
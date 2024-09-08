﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивСтруктурЭД = Новый Массив;
	Документообороты = Новый Массив;
	
	Если Параметры.Свойство("СтруктураЭД", МассивСтруктурЭД) Тогда
		Для Каждого СтруктураОбмена Из МассивСтруктурЭД Цикл
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОбмена);
			НоваяСтрока.ПредставлениеЭД = НоваяСтрока.ИмяФайла;
		КонецЦикла;
	ИначеЕсли Параметры.Свойство("Документообороты", Документообороты) Тогда
		
		СвойстваДокументооборотов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Документообороты, "ВидДокумента, НомерДокумента, ДатаДокумента");
		
		Для Каждого Документооборот Из СвойстваДокументооборотов Цикл
			НоваяСтрока = ТаблицаДанных.Добавить();
			НоваяСтрока.ЭлектронныйДокумент = Документооборот.Ключ;
			
			ПараметрыПредставления = ЭлектронныеДокументыЭДО.НовыеСвойстваПредставленияДокумента();
			ПараметрыПредставления.ВидДокумента = Документооборот.Значение.ВидДокумента;
			ПараметрыПредставления.НомерДокумента = Документооборот.Значение.НомерДокумента;
			ПараметрыПредставления.ДатаДокумента = Документооборот.Значение.ДатаДокумента;
			
			НоваяСтрока.ПредставлениеЭД = ЭлектронныеДокументыЭДО.ПредставлениеДокументаПоСвойствам(ПараметрыПредставления);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДанных

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВывестиЭДНаПросмотр(ТаблицаДанных[ВыбраннаяСтрока]);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПолноеИмяФайла");
	СтруктураПараметров.Вставить("ИмяФайла");
	СтруктураПараметров.Вставить("НаправлениеЭД");
	СтруктураПараметров.Вставить("Контрагент");
	СтруктураПараметров.Вставить("УникальныйИдентификатор");
	СтруктураПараметров.Вставить("ВладелецЭД");
	СтруктураПараметров.Вставить("ЭлектронныйДокумент");
	СтруктураПараметров.Вставить("АдресХранилищаФайла");
	СтруктураПараметров.Вставить("ФайлАрхива");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаДанных);
	Если ЗначениеЗаполнено(СтруктураПараметров.ЭлектронныйДокумент) Тогда
		ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокумент(СтрокаДанных.ЭлектронныйДокумент, Истина);
	Иначе
		ОткрытьФорму("Обработка.ИнтерфейсДокументовЭДО.Форма.ЗагрузкаПросмотрЭлектронногоДокумента",
			Новый Структура("СтруктураЭД", СтруктураПараметров), ЭтотОбъект, СтруктураПараметров.УникальныйИдентификатор);
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

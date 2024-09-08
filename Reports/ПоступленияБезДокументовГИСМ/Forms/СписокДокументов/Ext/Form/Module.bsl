﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Поступления")
		Или Не Параметры.Свойство("ДокументыГИСМ") Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	СформироватьЗаголовкиФормы(Параметры);
	ЗаполнитьТаблицуДокументов(Параметры);
	СформироватьПредставлениеОтборы(Параметры);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицаДокументов

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ТаблицаДокументовДокументПоступления Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.ДокументПоступления) Тогда
			ПоказатьЗначение(, ТекущиеДанные.ДокументПоступления);
		КонецЕсли;
	КонецЕсли;
	
	Если Поле = Элементы.ТаблицаДокументовДокументГИСМ Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.ДокументГИСМ) Тогда
			ПоказатьЗначение(, ТекущиеДанные.ДокументГИСМ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьЗаголовкиФормы(Параметры)

	Если Параметры.ИмяНабораДанных = "КиЗ" Тогда
		Заголовок = НСтр("ru = 'Несопоставленные документы поступления и ""Заявки на выпуски КиЗ""'");
		Элементы.ТаблицаДокументовДокументГИСМ.Заголовок = Метаданные.Документы.ЗаявкаНаВыпускКиЗГИСМ.Синоним;
	ИначеЕсли Параметры.ИмяНабораДанных = "МаркированныеТовары" Тогда
		Заголовок = НСтр("ru = 'Несопоставленные документы поступления и ""Уведомления о поступлении""'");
		Элементы.ТаблицаДокументовДокументГИСМ.Заголовок = Метаданные.Документы.УведомлениеОПоступленииМаркированныхТоваровГИСМ.Синоним;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументов(Параметры)

	КоличествоПоступлений    = Параметры.Поступления.Количество();
	КоличествоДокументовГИСМ = Параметры.ДокументыГИСМ.Количество();
	
	КоличествоСтрок = Макс(КоличествоПоступлений, КоличествоДокументовГИСМ);
	Для Инд = 1 По КоличествоСтрок Цикл
		НоваяСтрока = ТаблицаДокументов.Добавить();
		Если КоличествоПоступлений >= Инд Тогда
			НоваяСтрока.ДокументПоступления = Параметры.Поступления[Инд - 1];
		КонецЕсли;
		Если КоличествоДокументовГИСМ >= Инд Тогда
			НоваяСтрока.ДокументГИСМ = Параметры.ДокументыГИСМ[Инд - 1];
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтборы(Параметры)

	ТекстПредставленияОтбора = НСтр("ru = 'Номер КиЗ: %1, Организация : %2, Контрагент: %3.'");
	ПредставлениеОтборы = СтрШаблон(ТекстПредставленияОтбора, Параметры.НомерКиЗ, Параметры.Организация, Параметры.Контрагент);

КонецПроцедуры

#КонецОбласти

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	Соглашение = Справочники.СоглашенияСПоставщиками.ПустаяСсылка();
	
	Если Параметры.Свойство("Договор", Договор) Тогда
		Договор = Параметры.Договор;
	КонецЕсли;
	Если Параметры.Свойство("Соглашение") Тогда 
		Соглашение = Параметры.Соглашение;
	КонецЕсли;
	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Договор", Договор);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Соглашение", Соглашение);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("СостояниеНеНачат", НСтр("ru = 'Не начат'"));
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбранныйДокумент = Неопределено;
	
	ТекущиеДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ВыбранныйДокумент = ТекущиеДанные.Ссылка;
	КонецЕсли;
	Оповестить("ВыборДокументовПродажиДляОтчетаКомитенту", ВыбранныйДокумент, ЭтаФорма);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьДокумент(Команда)
	
	ВыбранныйДокумент = Неопределено;
	
	ТекущиеДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ВыбранныйДокумент = ТекущиеДанные.Ссылка;
	КонецЕсли;
	Оповестить("ВыборДокументовПродажиДляОтчетаКомитенту", ВыбранныйДокумент, ЭтаФорма);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СписокДокументовПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Если Не ПравоДоступа("Чтение", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Для каждого КлючСтрокиКОформлению Из Строки.ПолучитьКлючи() Цикл
			СтрокаСписка = Строки[КлючСтрокиКОформлению];
			СтрокаСписка.Оформление["Ссылка"].УстановитьЗначениеПараметра(
				"Текст", Строка(КлючСтрокиКОформлению));
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

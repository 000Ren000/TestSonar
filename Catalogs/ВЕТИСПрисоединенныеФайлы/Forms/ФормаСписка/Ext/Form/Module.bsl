﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда
		
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацииВЕТИС", ОрганизацииВЕТИС, СтруктураБыстрогоОтбора, Ложь);
		
		ОрганизацияВЕТИС = СтруктураБыстрогоОтбора.ОрганизацияВЕТИС;
		ОрганизацииВЕТИСПредставление = СтруктураБыстрогоОтбора.ОрганизацииВЕТИСПредставление;
		Если ОрганизацииВЕТИС.ПолучитьЭлементы().Количество() > 0
			И ПустаяСтрока(ОрганизацииВЕТИСПредставление) Тогда
			ОрганизацииВЕТИСПредставление = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеВыбранныхНастроек(ОрганизацииВЕТИС);
		КонецЕсли;
		ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
		
		ИнтеграцияВЕТИСКлиентСервер.ОрганизацияВЕТИСОтборПриИзменении(ЭтотОбъект, "");
		
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияВЕТИСКлиент.ОтборОрганизацияВЕТИСПрефиксы(),"");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.ДатаСоздания", Элементы.ДатаСоздания.Имя);
	
КонецПроцедуры

#КонецОбласти

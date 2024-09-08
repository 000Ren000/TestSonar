﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидыДокументов = Параметры.ВидыДокументов;
		
	СформироватьДеревоВидовДокументов(ВидыДокументов);
	Элементы.ОтборПоВидамДокументов.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	УстановитьУсловноеОформление();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ОтборПоВидамДокументов ФОРМЫ

&НаСервере
Процедура ДобавитьСтрокуДереваВидовДокументов(ОбъектМетаданных, СтрокаВерхнегоУровня)

	СтрокаДетальныеЗаписи = СтрокаВерхнегоУровня.Строки.Добавить();
	СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных = ОбъектМетаданных.Имя;
	СтрокаДетальныеЗаписи.ПолноеИмяМетаданных = ОбъектМетаданных.ПолноеИмя();
	СтрокаДетальныеЗаписи.Представление = ОбъектМетаданных.Синоним;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоВидовДокументов(МассивВыбранныхЗначений)

	ДеревоОтбора = РеквизитФормыВЗначение("ДеревоОтбораПоВидамДокументов", Тип("ДеревоЗначений"));
	ДеревоОтбора.Строки.Очистить();
	
	МетаДокументы = Метаданные.Документы;
	
	//++ Локализация 
	
	
	//-- Локализация
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Закупки'");
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратТоваровПоставщику, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЗаказПоставщику, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаПриобретения, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриобретениеТоваровУслуг, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриобретениеУслугПрочихАктивов, СтрокаВерхнегоУровня); 
	//++ Локализация 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураПолученный, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураПолученныйАванс, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураПолученныйНалоговыйАгент, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ТаможеннаяДекларацияИмпорт, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УведомлениеОВвозеПрослеживаемыхТоваров, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УведомлениеОбОстаткахПрослеживаемыхТоваров, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УведомлениеОПеремещенииПрослеживаемыхТоваров, СтрокаВерхнегоУровня);
	
	//-- Локализация
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Казначейство'");
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.АвансовыйОтчет, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВнесениеДенежныхСредствВКассуККМ, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВзаимозачетЗадолженности, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВыемкаДенежныхСредствИзКассыККМ, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЗаявкаНаРасходованиеДенежныхСредств, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаЗадолженности, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.НачисленияКредитовИДепозитов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОперацияПоПлатежнойКарте, СтрокаВерхнегоУровня); 
	//++ Локализация
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОперацияПоЯндексКассе, СтрокаВерхнегоУровня);  
	//-- Локализация
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетБанкаПоОперациямЭквайринга, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеБезналичныхДенежныхСредств, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриходныйКассовыйОрдер, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходныйКассовыйОрдер, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СписаниеБезналичныхДенежныхСредств, СтрокаВерхнегоУровня);
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();  
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Продажи'");
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.АннулированиеПодарочныхСертификатов, СтрокаВерхнегоУровня); 	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.АктВыполненныхРабот, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратПодарочныхСертификатов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратТоваровОтКлиента, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратТоваровМеждуОрганизациями, СтрокаВерхнегоУровня);
	 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЗаказКлиента, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КассоваяСмена, СтрокаВерхнегоУровня);
  	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаРеализации, СтрокаВерхнегоУровня);  
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомиссионера, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомиссионераОСписании, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетПоКомиссииМеждуОрганизациями, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетПоКомиссииМеждуОрганизациямиОСписании, СтрокаВерхнегоУровня);
 	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомитенту, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомитентуОСписании, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетОРозничныхВозвратах, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетОРозничныхПродажах, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПередачаТоваровМеждуОрганизациями, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПередачаТоваровХранителю, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РеализацияПодарочныхСертификатов, СтрокаВерхнегоУровня);
    ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РеализацияТоваровУслуг, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РеализацияУслугПрочихАктивов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетНаОплатуКлиенту, СтрокаВерхнегоУровня);
	//++ Локализация
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураВыданный, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураВыданныйАванс, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураКомиссионеру, СтрокаВерхнегоУровня); 
	//-- Локализация
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Производство'");
	
	
	//++ Локализация
	
	
	//-- Локализация
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПередачаТоваровХранителю, СтрокаВерхнегоУровня); 
		
	//++ Локализация 
	
	
	//-- Локализация
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеТоваровОтХранителя, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриемкаТоваровНаХранение, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СборкаТоваров, СтрокаВерхнегоУровня);

	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Склад'");
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВнутреннееПотребление, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВыкупПринятыхНаХранениеТоваров, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЗаказНаПеремещение, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ИнвентаризационнаяОпись, СтрокаВерхнегоУровня); 
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОприходованиеИзлишковТоваров, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеТоваров, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПересортицаТоваров, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПересчетТоваров, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПрочееОприходованиеТоваров, СтрокаВерхнегоУровня); 
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СписаниеНедостачТоваров, СтрокаВерхнегоУровня);
			
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Прочее'");
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УстановкаЦенНоменклатуры, СтрокаВерхнегоУровня);  
	
	Для каждого СтрокаВерхнегоУровня Из ДеревоОтбора.Строки Цикл
		ВыбраныВсеЭлементы = Истина;    
		ВыбранаЧастьЭлементов = Ложь;
		Для каждого СтрокаДетальныеЗаписи Из СтрокаВерхнегоУровня.Строки Цикл
			Если МассивВыбранныхЗначений.Найти(СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных) = Неопределено Тогда
				ВыбраныВсеЭлементы = Ложь;
			Иначе
				СтрокаДетальныеЗаписи.Пометка = 1;//Истина;  
				ВыбранаЧастьЭлементов = Истина;
			КонецЕсли;
			СтрокаДетальныеЗаписи.ИндексКартинки = -1;
		КонецЦикла;
		Если ВыбраныВсеЭлементы Тогда
			СтрокаВерхнегоУровня.Пометка = 1;//Истина;
		ИначеЕсли ВыбранаЧастьЭлементов Тогда
		     СтрокаВерхнегоУровня.Пометка = 2;
		КонецЕсли;
		СтрокаВерхнегоУровня.ИндексКартинки = 0;  
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОтбора, "ДеревоОтбораПоВидамДокументов");
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	ЗаполнитьОтметки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ЗаполнитьОтметки(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтметки(ЗначениеОтметки, ИдентификаторЭлемента = Неопределено)
	Если ИдентификаторЭлемента <> Неопределено Тогда
		ЭлементДерева = ДеревоОтбораПоВидамДокументов.НайтиПоИдентификатору(ИдентификаторЭлемента);
		ЭлементыНижнегоУровня = ЭлементДерева.ПолучитьЭлементы();
		Для Каждого ЭлементНижнегоУровня Из ЭлементыНижнегоУровня Цикл
			ЭлементНижнегоУровня.Пометка = ЗначениеОтметки;
		КонецЦикла;
	Иначе
		ЭлементыВерхнегоУровня = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
		Для Каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
			ЭлементВерхнегоУровня.Пометка = ЗначениеОтметки;
			ЭлементыНижнегоУровня = ЭлементВерхнегоУровня.ПолучитьЭлементы();
			Для каждого ЭлементНижнегоУровня Из ЭлементыНижнегоУровня Цикл
				ЭлементНижнегоУровня.Пометка = ЗначениеОтметки;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВидамДокументовПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОтборПоВидамДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущиеДанные.Пометка = ТекущиеДанные.Пометка % 2;
		
		Если ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
			ЗначениеОтметки = ТекущиеДанные.Пометка;
			ЗаполнитьОтметки(ЗначениеОтметки, ТекущиеДанные.ПолучитьИдентификатор()); 
		Иначе
			Строка = Элементы.ОтборПоВидамДокументов.ТекущаяСтрока; 
			ПоставитьПометкиИерархическиНаСервере(Строка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоставитьПометкиИерархическиНаСервере(Строка)
	ЭлементДанных = ДеревоОтбораПоВидамДокументов.НайтиПоИдентификатору(Строка);
	ПроставитьПометкиВверх(ЭлементДанных);
КонецПроцедуры

// Рекурсивное обслуживание иерархических пометок с тремя состояниями в дереве. 
//
// Параметры:
//    ДанныеСтроки - ДанныеФормыЭлементДерева - пометка хранится в числовой колонке "Пометка".
//
&НаСервере
Процедура ПроставитьПометкиВверх(ДанныеСтроки) Экспорт
	РодительСтроки = ДанныеСтроки.ПолучитьРодителя();
	Если РодительСтроки <> Неопределено Тогда
		ВсеИстина = Истина;
		НеВсеЛожь = Ложь;
		Для Каждого Потомок Из РодительСтроки.ПолучитьЭлементы() Цикл
			ВсеИстина = ВсеИстина И (Потомок.Пометка = 1);
			НеВсеЛожь = НеВсеЛожь Или Булево(Потомок.Пометка);
		КонецЦикла;
		Если ВсеИстина Тогда
			РодительСтроки.Пометка = 1;
		ИначеЕсли НеВсеЛожь Тогда
			РодительСтроки.Пометка = 2;
		Иначе
			РодительСтроки.Пометка = 0;
		КонецЕсли;
		ПроставитьПометкиВверх(РодительСтроки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("АдресТаблицыВоВременномХранилище", СформироватьТаблицуВыбранныхЗначений());
	ПараметрыЗакрытияФормы.Вставить("ИмяТаблицыДляЗаполнения",          "ВидыДокументов");
		
	ОповеститьОВыборе(ПараметрыЗакрытияФормы);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений()

	ТаблицаВыбранныхЗначений = Новый ТаблицаЗначений;
	ТаблицаВыбранныхЗначений.Колонки.Добавить("ИмяОбъектаМетаданных"); 
	ТаблицаВыбранныхЗначений.Колонки.Добавить("ТипДокумента");
	ТаблицаВыбранныхЗначений.Колонки.Добавить("Представление");
	ТаблицаВыбранныхЗначений.Колонки.Добавить("Использовать");
	
	ЭлементыВерхнегоУровня = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
	Для каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
		ЭлементыДетальныхЗаписей = ЭлементВерхнегоУровня.ПолучитьЭлементы();
		Для каждого ЭлементДетальныхЗаписей Из ЭлементыДетальныхЗаписей Цикл
			Если Не ЭлементДетальныхЗаписей.Пометка Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ТаблицаВыбранныхЗначений.Добавить();
			НоваяСтрока.ИмяОбъектаМетаданных = ЭлементДетальныхЗаписей.ИмяОбъектаМетаданных;
			НоваяСтрока.Представление = ЭлементДетальныхЗаписей.Представление;
			НоваяСтрока.Использовать = Истина;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыбранныхЗначений, УникальныйИдентификатор);

КонецФункции
&НаКлиенте
Процедура ОбновитьДекорациюПредупреждение(ИмяОбъектаМетаданных, ИмяГруппы)  
	Если Элементы.ГруппаПредупреждение.Видимость Тогда 
		Возврат;
	КонецЕсли;	
	МассивЗависимыхДокументов = Новый Массив;
	МассивЗависимыхДокументов.Добавить("фактуры"); 
	МассивЗависимыхДокументов.Добавить("счетфактура");
	МассивЗависимыхДокументов.Добавить("корректировка");
	МассивЗависимыхДокументов.Добавить("продажи");
	МассивЗависимыхДокументов.Добавить("закупки");
	Если ИмяОбъектаМетаданных = "УстановкаЦенНоменклатуры" Тогда
		Элементы.ГруппаПредупреждение.Видимость = Истина;
		Элементы.ГруппаПредупреждение.Заголовок = НСтр("ru = 'Для установки отбора по видам цен для документа воспользуйтесь настройкой - Выгружать с отбором по видам цен номенклатуры'");	
	КонецЕсли;

	Для каждого СтрокаМассива Из МассивЗависимыхДокументов Цикл
		Если НЕ Найти(Нрег(ИмяГруппы), СтрокаМассива) = 0 
			ИЛИ НЕ Найти(Нрег(ИмяОбъектаМетаданных), СтрокаМассива) = 0 Тогда
		    Элементы.ГруппаПредупреждение.Видимость = Истина;
			Возврат
		КонецЕсли;
	КонецЦикла; 
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВидамДокументовПриИзменении(Элемент)
	Если Элемент.ТекущиеДанные.Пометка Тогда  
		 ИмяГруппы = Элемент.ТекущиеДанные.Представление;
	     ИмяОбъектаМетаданных = Элемент.ТекущиеДанные.ИмяОбъектаМетаданных;
		 ОбновитьДекорациюПредупреждение(ИмяОбъектаМетаданных, ИмяГруппы)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	ДеревоОтбора = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
	ИмяДерева = "ОтборПоВидамДокументов"; 
	Развернуть = СвернутьДерево; 
	Для Каждого ЭлементКоллекции Из ДеревоОтбора Цикл
		ВложенныеЭлементыКоллекции = ЭлементКоллекции;
		Если Развернуть = Истина Тогда
			Элементы[ИмяДерева].Развернуть(ЭлементКоллекции.ПолучитьИдентификатор());
		Иначе
			Элементы[ИмяДерева].Свернуть(ЭлементКоллекции.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	СвернутьДерево = НЕ СвернутьДерево;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();     
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтборПоВидамДокументов.Имя);                               
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтбораПоВидамДокументов.ИмяОбъектаМетаданных");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина,,));
КонецПроцедуры

#КонецОбласти
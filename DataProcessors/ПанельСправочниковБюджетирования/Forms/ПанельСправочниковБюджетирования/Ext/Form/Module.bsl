﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Заголовок = НСтр("ru = 'Настройки и справочники по планированию'");
	Иначе
		Заголовок = НСтр("ru = 'Настройки и справочники по бюджетированию и планированию'");
	КонецЕсли;
	
	// Настройки видимости при запуске
	УправлениеЭлементами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьМоделиБюджетирования(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтатьиБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАналитикиСтатейБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСценарии(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПоказателиБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвязиПоказателейБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНефинансовыеПоказатели(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьШаблоныВводаНефинансовыхПоказателей(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПравилаПолученияФактическихДанных(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭтапыБюджетногоПроцесса(Команда)
	
	Возврат; // в УТ2 и КА2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьМодельБюджетирования(Команда)
	
	Возврат; // в УТ11 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМодельБюджетирования(Команда)
	
	Возврат; // в УТ11 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсточникиДанныхПланирования(Команда)
	
	ОткрытьФорму("Справочник.ИсточникиДанныхПланирования.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыПланов(Команда)
	
	ОткрытьФорму("Справочник.ВидыПланов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСценарииПланирования(Команда)
	
	ОткрытьФорму("Справочник.СценарииТоварногоПланирования.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСезонныеКоэффициенты(Команда)
	
	ОткрытьФорму("РегистрСведений.СезонныеКоэффициенты.Форма.СезонныеКоэффициенты",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСезонныеГруппыБизнесРегионов(Команда)
	
	ОткрытьФорму("Справочник.СезонныеГруппыБизнесРегионов.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНормативыРаспределения(Команда)
	
	ОткрытьФорму("Документ.НормативРаспределенияПлановПродажПоКатегориям.Форма.ФормаРедактирования",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыДоступаВидовБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыДоступаСтатейИПоказателейБюджетов(Команда)
	
	Возврат; // в УТ2 не используется
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементами()
	
	
	
	
	ЕстьДанныеДляОтображенияБюджетирование = Ложь;
	
			
	// Планирование
	ИспользоватьПланирование = 
		ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродажПоКатегориям")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеВнутреннихПотреблений");
	
	ПравоДоступаИсточникиДанныхПланирования = ПравоДоступа("Просмотр", Метаданные.Справочники.ИсточникиДанныхПланирования);
	ПравоДоступаСценарииПланирования        = ПравоДоступа("Просмотр", Метаданные.Справочники.СценарииТоварногоПланирования);
	ПравоДоступаВидыПланов                  = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыПланов);
	ПравоДоступаСезонныеКоэффициенты        = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.СезонныеКоэффициенты);
	ПравоДоступаСезонныеГруппыБизнесРегионов= ПравоДоступа("Просмотр", Метаданные.Справочники.СезонныеГруппыБизнесРегионов);
	ПравоДоступаНормативыРаспределения      = ПравоДоступа("Просмотр", Метаданные.Документы.НормативРаспределенияПлановПродажПоКатегориям);
	
	Элементы.ОткрытьИсточникиДанныхПланирования.Видимость = ПравоДоступаИсточникиДанныхПланирования;
	Элементы.ОткрытьСценарииПланирования.Видимость = ПравоДоступаСценарииПланирования;
	Элементы.ОткрытьВидыПланов.Видимость = ПравоДоступаВидыПланов;
	Элементы.ОткрытьСезонныеКоэффициенты.Видимость = ПравоДоступаСезонныеКоэффициенты;
	Элементы.ОткрытьСезонныеГруппыБизнесРегионов.Видимость = ПравоДоступаСезонныеГруппыБизнесРегионов;
	Элементы.ОткрытьНормативыРаспределения.Видимость = ПравоДоступаНормативыРаспределения;
	
			
	ЕстьДанныеДляОтображенияПланирование = ИспользоватьПланирование
		И (ПравоДоступаИсточникиДанныхПланирования
			Или ПравоДоступаСценарииПланирования
			Или ПравоДоступаВидыПланов
			Или ПравоДоступаСезонныеКоэффициенты
			Или ПравоДоступаСезонныеГруппыБизнесРегионов
			Или ПравоДоступаНормативыРаспределения);
		
		
	Если ЕстьДанныеДляОтображенияБюджетирование Или ЕстьДанныеДляОтображенияПланирование Тогда
		Элементы.ГруппаНеУстановленыНеобходимыеНастройки.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

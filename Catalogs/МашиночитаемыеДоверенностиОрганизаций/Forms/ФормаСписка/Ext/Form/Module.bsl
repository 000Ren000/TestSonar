﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоИзменения = Справочники.МашиночитаемыеДоверенностиОрганизаций.ЕстьПравоИзменения();
	Элементы.ФормаЗагрузить.Видимость = ЕстьПравоИзменения;
	Элементы.ФормаОтменить.Видимость = ЕстьПравоИзменения;
	Элементы.ФормаЗагрузитьПерезаполнитьИзФайла.Видимость = ЕстьПравоИзменения;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра(
		"БудетОтозвана", МашиночитаемыеДоверенностиКлиентСервер.ЗаголовокБудетОтозвана());
	Список.Параметры.УстановитьЗначениеПараметра("Да", НСтр("ru = 'Да'"));
	Список.Параметры.УстановитьЗначениеПараметра("Нет", НСтр("ru = 'Нет'"));
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.КолонкаСостоянияЭДО = Элементы.ПредставлениеСостояния;
	ПараметрыПриСозданииНаСервере.Направление = Перечисления.НаправленияЭДО.Исходящий;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбщегоНазначенияБЭД.ДобавитьСлужебноеПолеВДинамическийСписок(Список, "ВидимостьКомандМЧД");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Элементы.ФормаОтменить.Видимость = ТекущиеДанные.ВидимостьКомандМЧД["ОтменаДоверенности"];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПредставлениеСостояния Тогда
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаСписка(ВыбраннаяСтрока, СтандартнаяОбработка);
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	МашиночитаемыеДоверенности.ОпределитьВидимостьКомандМЧДПриПолученииДанныхСпискаНаСервере(Строки);
	МашиночитаемыеДоверенности.ПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	МашиночитаемыеДоверенностиКлиент.ПолучитьДанныеМЧД(ОписаниеОповещения, ЭтотОбъект, Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МашиночитаемыеДоверенностиКлиент.ОтменитьМЧД( , ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайла(Команда)
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ЗагрузитьПерезаполнитьИзФайлаЗавершение", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Архив'") + " (*.zip)|*.zip";
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите архив с доверенностью и подписью'");
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭДО(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		МашиночитаемыеДоверенностиКлиент.ОтправитьПоЭДО(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлектронныеДокументы(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИнтерфейсДокументовЭДОКлиент.ОткрытьДеревоЭлектронныхДокументов(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьОтозванной(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаЭлементСправочника = Элементы.Список.ТекущаяСтрока;
	ПараметрыФормы = Новый Структура("Ключ", СсылкаНаЭлементСправочника);
	ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаПросмотра", ПараметрыФормы);
	
	ТекстСообщения = НСтр("ru = 'Для изменения пометки отозвана выполните: Еще - Пометить отозванной/Вернуть в работу'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат.СсылкаНаДоверенность) Тогда
		Если Результат.Свойство("ТекстОшибки") Тогда
			МашиночитаемыеДоверенностиКлиент.ПоказатьПредупреждениеПриЗагрузкеМЧД(Результат.ТекстОшибки);
		КонецЕсли;
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Ключ, ОбновитьСостояниеПриОткрытии", Результат.СсылкаНаДоверенность, Истина);
	УИДФормы = Новый УникальныйИдентификатор;
	Если ТипЗнч(Результат.СсылкаНаДоверенность) = Тип("СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций") Тогда
		ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиОрганизаций.ФормаОбъекта", ПараметрыФормы,, УИДФормы);
	ИначеЕсли ТипЗнч(Результат.СсылкаНаДоверенность) = Тип(
		"СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов") Тогда
		ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиКонтрагентов.ФормаОбъекта", ПараметрыФормы,, УИДФормы);
	Иначе
		ПоказатьЗначение(Новый ОписаниеОповещения, Результат.СсылкаНаДоверенность);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайлаЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПомещенныйФайл.Хранение;
	МашиночитаемыеДоверенностиКлиент.ЗагрузитьМЧДИзФайла(АдресВоВременномХранилище);
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
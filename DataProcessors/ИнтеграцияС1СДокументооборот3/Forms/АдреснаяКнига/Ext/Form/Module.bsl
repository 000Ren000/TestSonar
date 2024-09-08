﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоПодразделений(Дерево.ПолучитьЭлементы(), "DMSubdivision", "");
	ЭлементВсеПользователи = Дерево.ПолучитьЭлементы().Вставить(0);
	ЭлементВсеПользователи.Наименование = НСтр("ru = 'Все сотрудники'");
	ЭлементВсеПользователи.ID = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = Дерево.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.ID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПользователиРолиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Роли.Количество() = 0 Тогда
		ЗаполнитьСписокДоступныхРолей();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РолиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПользователей

&НаКлиенте
Процедура ТаблицаПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьВыполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПодразделений(ВеткаДерева, ТипОбъектаВыбора, ИдентификаторПапки = Неопределено,
		СтрокаПоиска = Неопределено)
	
	ВеткаДерева.Очистить();
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Условия = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	СписокУсловийОтбора = Условия.conditions; // СписокXDTO
	
	Если ИдентификаторПапки <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Parent";
		Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ИдентификаторПапки,
			ТипОбъектаВыбора);
		
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Если СтрокаПоиска <> Неопределено Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Name";
		Условие.value = СтрокаПоиска;
		
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		ТипОбъектаВыбора,
		Условия);
	
	Для Каждого Элемент Из Результат.Items Цикл
		
		НоваяСтрока = ВеткаДерева.Добавить();
		НоваяСтрока.Наименование = Элемент.object.name;
		НоваяСтрока.ID = Элемент.object.objectID.ID;
		НоваяСтрока.Тип = Элемент.object.objectID.type;
		
		Если ТипОбъектаВыбора = "DMFileFolder" Тогда
			НоваяСтрока.Картинка = 0;
		Иначе
			Если Элемент.isFolder Тогда
				НоваяСтрока.Картинка = 0;
			Иначе
				НоваяСтрока.Картинка = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если Элемент.canHaveChildren И (СтрокаПоиска = Неопределено) Тогда
			НоваяСтрока.ПодпапкиСчитаны = Ложь;
			НоваяСтрока.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
		Иначе
			НоваяСтрока.ПодпапкиСчитаны = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПользователей(ПодразделениеИД)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	// Получение руководителя текущего подразделения
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		Подразделение = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
			Прокси,
			"DMSubdivision",
			ПодразделениеИД);
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(Подразделение, "head") Тогда
			IDРуководителя = Подразделение.head.objectID.ID;
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение списка пользователей
	Условия = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	СписокУсловийОтбора = Условия.conditions; // СписокXDTO
	
	Если ЗначениеЗаполнено(ПодразделениеИД) Тогда
		Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси,"DMObjectListCondition");
		Условие.property = "Subdivision";
		Условие.value = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			ПодразделениеИД,
			"DMSubdivision");
		СписокУсловийОтбора.Добавить(Условие);
	КонецЕсли;
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMEmployee",
		Условия);
	
	ТаблицаПользователей.Очистить();
	Для Каждого ПользовательВСписке Из Результат.Items Цикл
		НоваяСтрока = ТаблицаПользователей.Добавить();
		НоваяСтрока.Пользователь = ПользовательВСписке.object.name;
		НоваяСтрока.ПользовательID = ПользовательВСписке.object.objectID.ID;
		НоваяСтрока.ПользовательТип = ПользовательВСписке.object.objectID.type;
		НоваяСтрока.Руководитель = (IDРуководителя = ПользовательВСписке.object.objectID.ID);
	КонецЦикла;
	
	ТаблицаПользователей.Сортировать("Пользователь Возр");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = Дерево.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПодразделений(Лист.ПолучитьЭлементы(), "DMSubdivision", Лист.ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	ЗаполнитьТаблицуПользователей(Элементы.Дерево.ТекущиеДанные.ID);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхРолей()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	УсловияОтбораОбъектов = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		"DMObjectListQuery");
	
	Результат = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMBusinessProcessExecutorRole",
		УсловияОтбораОбъектов);
	
	Роли.Очистить();
	Для Каждого Элемент Из Результат.Items Цикл
		НоваяСтрока = Роли.Добавить();
		НоваяСтрока.Роль = Элемент.object.name;
		НоваяСтрока.РольID = Элемент.object.objectID.ID;
		НоваяСтрока.РольТип = Элемент.object.objectID.type;
		НоваяСтрока.Картинка = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексКартинкиЭлементаСправочника();
	КонецЦикла;
	
	Роли.Сортировать("Роль Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если Элементы.ГруппаПользователиРоли.ТекущаяСтраница = Элементы.ГруппаПользователи Тогда
		
		Если Элементы.ТаблицаПользователей.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеВозврата = Новый Структура;
		ДанныеВозврата.Вставить("Исполнитель",
			Элементы.ТаблицаПользователей.ТекущиеДанные.Пользователь);
		ДанныеВозврата.Вставить("ИсполнительID",
			Элементы.ТаблицаПользователей.ТекущиеДанные.ПользовательID);
		ДанныеВозврата.Вставить("ИсполнительТип",
			Элементы.ТаблицаПользователей.ТекущиеДанные.ПользовательТип);
		
		Закрыть(ДанныеВозврата);
		
	ИначеЕсли Элементы.ГруппаПользователиРоли.ТекущаяСтраница = Элементы.ГруппаРоли Тогда
		
		Если Элементы.Роли.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВыбратьВыполнитьЗавершение", ЭтотОбъект);
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПоказатьПолучениеОбъектовАдресацииРоли(
			Оповещение,
			Элементы.Роли.ТекущиеДанные.Роль,
			Элементы.Роли.ТекущиеДанные.РольТип,
			Элементы.Роли.ТекущиеДанные.РольID,
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнитьЗавершение(ДанныеВозврата, ПараметрыОповещения) Экспорт
	
	Если ДанныеВозврата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ДанныеВозврата);
	
КонецПроцедуры

#КонецОбласти
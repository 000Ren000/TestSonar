﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок           = Параметры.Заголовок;
	ВыбранныеЗначения   = Параметры.ВыбранныеЗначения;
	ДоступныеЗначения   = Параметры.ДоступныеЗначения;
	ЗначениеОграничения = Параметры.ЗначениеОграничения;
	
	ЗаполнитьПредставленияЗначенийСписка(ВыбранныеЗначения);
	ЗаполнитьПредставленияЗначенийСписка(ДоступныеЗначения);
	
	ДоступныеЗначения.СортироватьПоПредставлению();
	ВыбранныеЗначения.СортироватьПоПредставлению();
	
	СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницу =
		РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП.СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницуНаДату();
	
	КоличествоВключенныхТоварныхГрупп           = СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницу.Количество();
	ВедетсяУчетТГТребующихОбязательногоКонтроля = КоличествоВключенныхТоварныхГрупп > 0;
	
	Элементы.ГруппаИнформация.Видимость         = Параметры.ПоказыватьПодсказкуОграниченияИсключений И ВедетсяУчетТГТребующихОбязательногоКонтроля;
	
	Если КоличествоВключенныхТоварныхГрупп > 0 Тогда
	
		РазделительТекстов = ?(КоличествоВключенныхТоварныхГрупп = 1, Символы.НПП, Символы.ПС + "—" + Символы.НПП);
		
		ТекстКомментария = ?(КоличествоВключенныхТоварныхГрупп = 1,
			НСтр("ru = 'Невозможно отключение контроля в ГИС МТ, потому что включен учет товарной группы, требующей согласно ФЗ № 381-ФЗ «Об основах торговой деятельности в Российской Федерации» обязательного учета при розничной продаже:'"),
			НСтр("ru = 'Невозможно отключение контроля в ГИС МТ, потому что включен учет товарных групп, требующих согласно ФЗ № 381-ФЗ «Об основах торговой деятельности в Российской Федерации» обязательного учета при розничной продаже:'"));
		
		Для Каждого ОбязательнаяГруппа Из СписокУчитываемойПродукцииТребующейОбязательнойПроверкиПриПродажеВРозницу Цикл
		
			ТекстКомментария = ТекстКомментария + РазделительТекстов + ОбязательнаяГруппа;
			
		КонецЦикла;
		
		СтрокаЗавершенияПодсказки = НСтр("ru = 'Настройка учитываемых видов продукции находится в разделе'");
		СтрокаГиперссылка         = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Панель интеграции с ИС МП'"),,
			ЦветаСтиля.ЦветГиперссылкиГосИС,,
			"ПерейтиВПанельАдминистрированияИСМП");
		
		МассивСтрокФорматированногоТекста = Новый Массив;
		
		МассивСтрокФорматированногоТекста.Добавить(ТекстКомментария);
		МассивСтрокФорматированногоТекста.Добавить(Символы.ПС);
		МассивСтрокФорматированногоТекста.Добавить(СтрокаЗавершенияПодсказки);
		МассивСтрокФорматированногоТекста.Добавить(Символы.НПП);
		МассивСтрокФорматированногоТекста.Добавить(СтрокаГиперссылка);
		
		Элементы.Комментарий.Заголовок = Новый ФорматированнаяСтрока(МассивСтрокФорматированногоТекста);
		
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиВПанельАдминистрированияИСМП" Тогда
		
		ИмяФормыНастройкиИСМП = "Обработка.ПанельАдминистрированияИСМП.Форма.НастройкиИСМП";
		
		ОткрытьФорму(ИмяФормыНастройкиИСМП);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступныеЗначения

&НаКлиенте
Процедура ДоступныеЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПереместитьЭлемент(Элементы.ДоступныеЗначения.Имя, Элементы.ВыбранныеЗначения.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеЗначения

&НаКлиенте
Процедура ВыбранныеЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПереместитьЭлемент(Элементы.ВыбранныеЗначения.Имя, Элементы.ДоступныеЗначения.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьЭлемент(Команда)
	
	ПереместитьЭлемент(Элементы.ДоступныеЗначения.Имя, Элементы.ВыбранныеЗначения.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВсеЭлементы(Команда)
	
	ПереместитьВсеЭлементы(Элементы.ДоступныеЗначения.Имя, Элементы.ВыбранныеЗначения.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЭлемент(Команда)
	
	ПереместитьЭлемент(Элементы.ВыбранныеЗначения.Имя, Элементы.ДоступныеЗначения.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеЭлементы(Команда)
	
	ПереместитьВсеЭлементы(Элементы.ВыбранныеЗначения.Имя, Элементы.ДоступныеЗначения.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ВыбранныеЗначения.СортироватьПоПредставлению();
	Закрыть(ВыбранныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДоступныеВидыПродукцииЗначение");
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ДоступныеВидыПродукцииЗначение.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = ЗначениеОграничения;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ВыбранныеВидыПродукцииЗначение");
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВыбранныеВидыПродукцииЗначение.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = ЗначениеОграничения;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПредставленияЗначенийСписка(Список)
	
	Для Каждого Элемент Из Список Цикл
		Если ЗначениеЗаполнено(Элемент.Представление) Тогда
			Продолжить;
		КонецЕсли;
		Элемент.Представление = Строка(Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлемент(ИмяИсточника, ИмяПриемника)
	
	ТекущиеДанные = Элементы[ИмяИсточника].ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеОграничения.НайтиПоЗначению(ТекущиеДанные.Значение) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ИмяПриемника].Добавить(ТекущиеДанные.Значение, ТекущиеДанные.Представление);
	
	ЭтотОбъект[ИмяПриемника].СортироватьПоПредставлению();
	
	ЭтотОбъект[ИмяИсточника].Удалить(ЭтотОбъект[ИмяИсточника].НайтиПоИдентификатору(Элементы[ИмяИсточника].ТекущаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВсеЭлементы(ИмяИсточника, ИмяПриемника)
	
	Если ЭтотОбъект[ИмяИсточника].Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияДляУдаления = Новый Массив();
	
	Для Каждого ЭлементСписка Из ЭтотОбъект[ИмяИсточника] Цикл
		
		Если ЗначениеОграничения.НайтиПоЗначению(ЭлементСписка.Значение) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭтотОбъект[ИмяПриемника].Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		
		ЗначенияДляУдаления.Добавить(ЭлементСписка.Значение);
		
	КонецЦикла;
	
	ЭтотОбъект[ИмяПриемника].СортироватьПоПредставлению();
	
	Для Каждого Элемент Из ЗначенияДляУдаления Цикл
		
		ЭтотОбъект[ИмяИсточника].Удалить(ЭтотОбъект[ИмяИсточника].НайтиПоЗначению(Элемент));
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

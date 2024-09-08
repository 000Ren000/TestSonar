﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Основание) Тогда
		Если НЕ ПравоДоступа("Чтение", Метаданные.НайтиПоТипу(ТипЗнч(Объект.Основание))) Тогда
			Элементы.ГруппаОснование.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		УстановитьЗаголовокФормыЭлемента(Истина);
		СамообслуживаниеСервер.ФормыСамообслуживаниеПриСозданииНаСервере(ЭтаФорма, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ПартнерыИКонтактныеЛица.ОтборСтрок = Новый ФиксированнаяСтруктура("Партнер", Объект.Партнер);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если ТекущийОбъект.Статус <> Перечисления.СтатусыПретензийКлиентов.Зарегистрирована Тогда
		ТребуетсяОткрытиеПечатнойФормы = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьВложения();
	УстановитьЗаголовокФормыЭлемента(Ложь);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РассылкиИОповещенияКлиентам.УдалитьВложения(УдаленныеВложения);
	РассылкиИОповещенияКлиентам.СохранитьВложения(ТекущийОбъект.Ссылка, Вложения, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Для каждого СтрокаУчастник Из Объект.ПартнерыИКонтактныеЛица Цикл
	
		Если СтрокаУчастник.Партнер = Объект.Партнер И Не ЗначениеЗаполнено(СтрокаУчастник.КонтактноеЛицо) Тогда
			
			ИмяПоля = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.ПартнерыИКонтактныеЛица",
			                                                           СтрокаУчастник.НомерСтроки,
			                                                           "КонтактноеЛицо");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			       НСтр("ru = 'Необходимо указать контактное лицо'"),
			       Объект.Ссылка,
			       ИмяПоля,
			       ,
			       Отказ);
		КонецЕсли;
	
	КонецЦикла;
	
	Если Не Отказ Тогда
		
		РассылкиИОповещенияКлиентамКлиент.ПоместитьВложенияВоВременноеХранилище(Вложения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьПретензияКлиента(Объект.Ссылка);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
		
	УстановитьЗаголовокФормыЭлемента(Ложь);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Основание) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Объект.Основание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПартнерыИКонтактныеЛица

&НаКлиенте
Процедура ПартнерыИКонтактныеЛицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		ТекущиеДанные.Партнер = Объект.Партнер;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	РассылкиИОповещенияКлиентамКлиент.ДобавитьВложениеВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьВложениеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьВложениеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	РассылкиИОповещенияКлиентамКлиент.ОбработатьПеретаскиваниеВложения(Вложения, ПараметрыПеретаскивания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	УдалитьВложениеВыполнить();
	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВложениеВыполнить()
	
	РассылкиИОповещенияКлиентамКлиент.ДобавитьВложениеВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложениеВыполнить()
	
	РассылкиИОповещенияКлиентамКлиент.ОткрытьВложениеВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВложениеВыполнить()

	РассылкиИОповещенияКлиентамКлиент.ПереместитьВложениеВУдаленные(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовокФормыЭлемента(ЭтоНовыйОбъект)

	Если ЭтоНовыйОбъект Тогда
		
		Заголовок = НСтр("ru = 'Претензия (создание)'");
		
	Иначе
		
		Заголовок = Объект.Наименование + " (" + НСтр("ru = 'претензия'") + ")";
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВложения()

	Вложения.Очистить();
	ТаблицаВложений = СамообслуживаниеСервер.ВложенияОбъектаМетаданных(Объект.Ссылка, Истина);
	Для Каждого СтрокаТаблицыВложений Из ТаблицаВложений Цикл
		НоваяСтрока = Вложения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыВложений);
		НоваяСтрока.Расположение = 0;
	КонецЦикла;

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

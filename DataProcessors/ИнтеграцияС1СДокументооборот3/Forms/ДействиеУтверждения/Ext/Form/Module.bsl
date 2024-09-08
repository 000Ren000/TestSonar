﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3.ПриСозданииНаСервереФормыДействия(ЭтотОбъект, Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьПодключение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УдалениеУчастниковДействия" И Источник = УникальныйИдентификатор Тогда
		ОбновитьПредставленияВДеревеУчастников(Участники);
		УстановитьДоступностьЭлементовФормы();
		
	ИначеЕсли ИмяСобытия = "ОбновитьПредставленияВДеревеУчастников" И Источник = УникальныйИдентификатор Тогда
		ОбновитьПредставленияВДеревеУчастников(Участники);
		УстановитьДоступностьЭлементовФормы();
		ИнтеграцияС1СДокументооборот3Клиент.УчастникиДействияПриАктивизацииСтроки(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборот3Клиент.ВыбратьСотрудникаИзДереваПодразделений("Автор", ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMEmployee",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMEmployee",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Автор",
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка,
				ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Автор",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОчистка(Элемент, СтандартнаяОбработка)
	
	Автор = "";
	АвторID = "";
	АвторТип = "";
	АвторПредставление = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот";
	
	ОткрытьФорму(ИмяФормыПараметров,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ПриПодключении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОтложенногоНачалаВыполненияНажатие(Элемент, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.ОписаниеОтложенногоНачалаВыполненияДействияНажатие(
		ЭтотОбъект,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчастники

&НаКлиенте
Процедура УчастникиПриИзменении(Элемент)
	
	ОбновитьПредставленияВДеревеУчастников(Участники);
	ИнтеграцияС1СДокументооборот3Клиент.РазвернутьДеревоУчастниковДействия(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	ИнтеграцияС1СДокументооборот3Клиент.УчастникиДействияПриАктивизацииСтроки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередУдалением(Элемент, Отказ)
	
	ИнтеграцияС1СДокументооборот3Клиент.УчастникиДействияПередУдалением(ЭтотОбъект, Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломИзменения(Элемент, Отказ)
	
	ИнтеграцияС1СДокументооборот3Клиент.УчастникиДействияПередНачаломИзменения(ЭтотОбъект, Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Участники.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущиеДанные <> Неопределено Тогда
		ОткрыватьОсобоеНаименованиеИОписание = Не ТекущиеДанные.ЭтоЭтап
			И (ТекущиеДанные.Функция = "ConfirmingPerson");
		РазрешениеОбщее = Неопределено;
		Если Разрешения.Количество() > 0 Тогда
			РазрешениеОбщее = Разрешения[0].Разрешение;
		КонецЕсли;
		ТолькоПросмотрОсобогоНаименованияИОписания = ТолькоПросмотр
			Или (РазрешениеОбщее = "Forbidden")
			Или (РазрешениеОбщее = Неопределено);
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборот3Клиент.УчастникиДействияВыбор(
		ЭтотОбъект,
		ВыбраннаяСтрока,
		Поле,
		СтандартнаяОбработка,
		ОткрыватьОсобоеНаименованиеИОписание,
		ТолькоПросмотрОсобогоНаименованияИОписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПредставлениеУчастникаДействияНачалоВыбора(
		Элемент,
		ДанныеВыбора,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПредставлениеУчастникаДействияАвтоПодбор(
		Элемент,
		Текст,
		ДанныеВыбора,
		ПараметрыПолученияДанных,
		Ожидание,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПредставлениеУчастникаДействияОкончаниеВводаТекста(
		Элемент,
		Текст,
		ДанныеВыбора,
		ПараметрыПолученияДанных,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПредставлениеУчастникаДействияОбработкаВыбора(
		Элемент,
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСтрокиОчистка(Элемент, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПредставлениеУчастникаДействияОчистка(
		Элемент,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеПриИзменении(Элемент)
	
	ИнтеграцияС1СДокументооборот3Клиент.СрокВыполненияДействияУчастникомПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборот3Клиент.СрокВыполненияДействияУчастникомРегулирование(ЭтотОбъект, Направление, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	ОбновитьПолеЕстьОсобоеНаименованиеОписание(Элементы.Участники.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьФорму(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьДиалог(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗадержку(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ОчиститьЗадержкуДействия(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Защищенный(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ИзменитьПризнакУчастникаДействияЗащищенный(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

// Заполняет представление сроков в карточке действия.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроков() Экспорт
	
	Для Каждого ЭтапУчастников Из Участники.ПолучитьЭлементы() Цикл
		
		Для Каждого УчастникЭтапа Из ЭтапУчастников.ПолучитьЭлементы() Цикл
			
			УчастникЭтапа.СрокПредставление =
				ИнтеграцияС1СДокументооборот3КлиентСервер.ПредставлениеСрокаИсполнения(
					УчастникЭтапа.Срок,
					УчастникЭтапа.СрокДни,
					УчастникЭтапа.СрокЧасы,
					УчастникЭтапа.СрокМинуты,
					ИспользоватьДатуИВремяВСрокахЗадач,
					УчастникЭтапа.ВариантУстановкиСрока);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы() Экспорт
	
	ТекущиеДанные = Элементы.Участники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоЭтап Тогда
		
		Элементы.ПредставлениеСтроки.ТолькоПросмотр = Истина;
		Элементы.СрокПредставление.ТолькоПросмотр = Истина;
		Элементы.ЕстьОсобоеНаименованиеОписание.ТолькоПросмотр = Истина;
		Элементы.Описание.ТолькоПросмотр = Истина;
		
	ИначеЕсли ТекущиеДанные.Функция = "ConfirmationResultProcessor" Тогда
		
		Элементы.ПредставлениеСтроки.ТолькоПросмотр = Ложь;
		Элементы.ПредставлениеСтроки.КнопкаВыбора = Истина;
		Элементы.СрокПредставление.ТолькоПросмотр = Ложь;
		Элементы.ЕстьОсобоеНаименованиеОписание.ТолькоПросмотр = Истина;
		Элементы.Описание.ТолькоПросмотр = Ложь;
		
	Иначе
		
		ТолькоПросмотрСтроки = (ТекущиеДанные.Состояние = "Completed");
		Элементы.ПредставлениеСтроки.ТолькоПросмотр = ТолькоПросмотрСтроки;
		Элементы.ПредставлениеСтроки.КнопкаВыбора = Истина;
		Элементы.СрокПредставление.ТолькоПросмотр = ТолькоПросмотрСтроки;
		Элементы.ЕстьОсобоеНаименованиеОписание.ТолькоПросмотр = ТолькоПросмотрСтроки;
		Элементы.Описание.ТолькоПросмотр = ТолькоПросмотрСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Сервер

&НаСервере
Процедура ОбработатьОтветВебСервисаНаПолучениеДействия(ДействиеXDTO)
	
	// Заполним общие данные действия.
	ИнтеграцияС1СДокументооборот3.ОбработатьОтветВебСервисаНаПолучениеДействия(ЭтотОбъект, ДействиеXDTO);
	
	// Обновим форму действия.
	ОбновитьДеревоУчастниковПоОбъекту(ДействиеXDTO);
	ИнтеграцияС1СДокументооборот3.УстановитьВидимостьУсловийУчастниковДействия(ЭтотОбъект, ДействиеXDTO);
	ИнтеграцияС1СДокументооборот3.ЗаполнитьСостоянияИРезультатыВФормеДействия(ЭтотОбъект, ДействиеXDTO);
	ИнтеграцияС1СДокументооборот3.УстановитьДоступностьИзмененияУчастниковДействия(ЭтотОбъект, Разрешения);
	
КонецПроцедуры

// Заполняет дерево участников по объекту.
//
&НаСервере
Процедура ОбновитьДеревоУчастниковПоОбъекту(ДействиеXDTO)
	
	ЭтапыУчастников = Участники.ПолучитьЭлементы();
	ЭтапыУчастников.Очистить();
	
	// Утверждение.
	ЭтапУтверждение = ЭтапыУчастников.Добавить();
	ЭтапУтверждение.Функция = "ConfirmingPerson";
	ЭтапУтверждение.НаименованиеЭтапа = НСтр("ru = 'Утвердить'");
	ЭтапУтверждение.ЭтоЭтап = Истина;
	
	УчастникиДействия = ДействиеXDTO.participantRows.rows;
	
	УчастникиЭтапа = ЭтапУтверждение.ПолучитьЭлементы();
	ДобавилиУчастника = Ложь;
	Утверждающие = ИнтеграцияС1СДокументооборот3.УчастникиДействияСФункцией(
		УчастникиДействия,
		"ConfirmingPerson");
	Для Каждого Утверждающий Из Утверждающие Цикл
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		ИнтеграцияС1СДокументооборот3.ЗаполнитьСтрокуУчастникаДействияИзXDTO(УчастникЭтапа, Утверждающий);
		УчастникЭтапа.Функция = Утверждающий.participantFunction;
		ДобавилиУчастника = Истина;
		ОбновитьПолеЕстьОсобоеНаименованиеОписание(УчастникЭтапа);
		Если Не ИнтеграцияС1СДокументооборот3КлиентСервер.ИдентификаторЗаполнен(УчастникЭтапа.Идентификатор) Тогда
			УчастникЭтапа.Идентификатор = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ДобавилиУчастника Тогда
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		УчастникЭтапа.Идентификатор = Строка(Новый УникальныйИдентификатор);
		УчастникЭтапа.Функция = ЭтапУтверждение.Функция;
	КонецЕсли;
	
	// Ознакомление.
	ЭтапОзнакомление = ЭтапыУчастников.Добавить();
	ЭтапОзнакомление.Функция = "ConfirmationResultProcessor";
	ЭтапОзнакомление.НаименованиеЭтапа = НСтр("ru = 'Ознакомиться с результатом утверждения'");
	ЭтапОзнакомление.ЭтоЭтап = Истина;
	
	УчастникиЭтапа = ЭтапОзнакомление.ПолучитьЭлементы();
	ДобавилиУчастника = Ложь;
	УчастникОбрабатывающийРезультат = ИнтеграцияС1СДокументооборот3.УчастникиДействияСФункцией(
		УчастникиДействия,
		"ConfirmationResultProcessor");
	Для Каждого ОбрабатывающийРезультат Из УчастникОбрабатывающийРезультат Цикл
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		ИнтеграцияС1СДокументооборот3.ЗаполнитьСтрокуУчастникаДействияИзXDTO(УчастникЭтапа, ОбрабатывающийРезультат);
		УчастникЭтапа.Функция = ОбрабатывающийРезультат.participantFunction;
		ДобавилиУчастника = Истина;
		Если Не ИнтеграцияС1СДокументооборот3КлиентСервер.ИдентификаторЗаполнен(УчастникЭтапа.Идентификатор) Тогда
			УчастникЭтапа.Идентификатор = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ДобавилиУчастника Тогда
		УчастникЭтапа = УчастникиЭтапа.Добавить();
		УчастникЭтапа.Идентификатор = Строка(Новый УникальныйИдентификатор);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			УчастникЭтапа,
			ДействиеXDTO.author,
			"Участник",
			Истина);
		УчастникЭтапа.Функция = ЭтапОзнакомление.Функция;
	КонецЕсли;
	
	ОбновитьПредставленияВДеревеУчастников(Участники);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОбъектПоДеревуУчастников(Прокси, ДействиеXDTO)
	
	ДействиеXDTO.participantRows = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		"DMActionConfirmationParticipantRows");
	УчастникиXDTO = ДействиеXDTO.participantRows.rows; // СписокXDTO
	
	ЕстьИсполняющиеУчастники = Ложь;
	ЕстьОбрабатывающийРезультат = Ложь;
	
	Для Каждого ЭлементЭтап Из Участники.ПолучитьЭлементы() Цикл
		
		Для Каждого ЭлементУчастник Из ЭлементЭтап.ПолучитьЭлементы() Цикл
			
			Если Не ЗначениеЗаполнено(ЭлементУчастник.УчастникID) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
				Прокси,
				"DMActionConfirmationParticipantRow");
			ИнтеграцияС1СДокументооборот3.ЗаполнитьСтрокуXDTOИзУчастникаДействия(Прокси, СтрокаXDTO, ЭлементУчастник);
			СтрокаXDTO.participantFunction = ЭлементЭтап.Функция;
			УчастникиXDTO.Добавить(СтрокаXDTO);
			
			Если Не ИнтеграцияС1СДокументооборот3КлиентСервер.ЭтоФункцияОбработатьРезультат(ЭлементЭтап.Функция) Тогда
				ЕстьИсполняющиеУчастники = Истина;
			Иначе
				ЕстьОбрабатывающийРезультат = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Если заполнен только "Обрабатывающий результат", то не сохраняем его.
	Если Не ЕстьИсполняющиеУчастники Тогда
		УчастникиXDTO.Очистить();
	ИначеЕсли Не ЕстьОбрабатывающийРезультат Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует участник ""ознакомления с результатом утверждения""'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеЕстьОсобоеНаименованиеОписание(Строка)
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка.ЕстьОсобоеНаименованиеОписание = ЗначениеЗаполнено(Строка.Описание);
	
КонецПроцедуры

// Обновляет представления строк в дереве участников.
//
// Параметры:
//   Участники - ДанныеФормыДерево - дерево с участниками.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставленияВДеревеУчастников(Участники)
	
	Для Каждого СтрокаЭтапа Из Участники.ПолучитьЭлементы() Цикл
		СтрокаЭтапа.ПредставлениеСтроки = СтрокаЭтапа.НаименованиеЭтапа;
		Для Каждого СтрокаУчастника Из СтрокаЭтапа.ПолучитьЭлементы() Цикл
			СтрокаУчастника.ПредставлениеСтроки = ИнтеграцияС1СДокументооборот3КлиентСервер.ПредставлениеУчастника(
				СтрокаУчастника);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Формирует объект XDTO для записи в Документообороте по данным из формы действия.
//
// Возвращаемое значение:
//   Строка - строковое представление объекта XDTO типа, наследующего DMAction.
//
&НаСервере
Функция ПодготовитьДействиеДляЗаписи()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	ДействиеXDTO = ИнтеграцияС1СДокументооборот3.ПодготовитьДействиеДляЗаписи(Прокси, ЭтотОбъект);
	
	ОбновитьОбъектПоДеревуУчастников(Прокси, ДействиеXDTO);
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.ОбъектXDTOВСтроку(Прокси, ДействиеXDTO);
	
КонецФункции

#КонецОбласти

#Область Подключение

// Проверяет подключение к ДО, выводя окно авторизации, если необходимо, и изменяя форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект,,
		Ложь,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ПриПодключении();
	Иначе // не удалось подключиться к ДО
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПодключении()
	
	Если ОбработатьФормуСогласноВерсииСервиса() Тогда
		ОбновитьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьФормуСогласноВерсииСервиса() Экспорт
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаДокументооборотНедоступен;
		Возврат Ложь;
	КонецЕсли;
	
	ФормаОбработанаУспешно = Истина;
	
	Попытка
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("3.0.13.29") Тогда
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаДокументооборотДоступен;
			
			НастройкиДокументооборота = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьНастройки();
			ИспользоватьДатуИВремяВСрокахЗадач = НастройкиДокументооборота.ИспользоватьДатуИВремяВСрокахЗадач;
			
		Иначе
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
			ФормаОбработанаУспешно = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.НужноОбработатьФорму(ИнформацияОбОшибке()) Тогда
			ОбработатьФормуСогласноВерсииСервиса();
		КонецЕсли;
		
	КонецПопытки;
	
	Возврат ФормаОбработанаУспешно;
	
КонецФункции

#КонецОбласти

#Область ОбновитьФорму

&НаКлиенте
Процедура ОбновитьФорму(ВыводитьОкноОжидания = Ложь, СкрыватьИнтерфейс = Истина)
	
	Если Не ВыводитьОкноОжидания И Не СкрыватьИнтерфейс Тогда
		Элементы.СтраницаДокументооборотДоступен.Доступность = Ложь;
	КонецЕсли;
	
	Колонки = Новый Массив;
	Если РежимДиалога Тогда
		Колонки.Добавить("dialogueMode");
	КонецЕсли;
	ДлительнаяОперация = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПолучитьОбъектАсинхронно(
		УникальныйИдентификатор,
		Тип,
		ID,
		Колонки);
	ПараметрыОповещения = Новый Структура("ВыводитьОкноОжидания, СкрыватьИнтерфейс",
		ВыводитьОкноОжидания,
		СкрыватьИнтерфейс);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьФормуЗавершение", ЭтотОбъект, ПараметрыОповещения);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьЗапросАсинхронно(
		ЭтотОбъект,
		ДлительнаяОперация,
		ОповещениеОЗавершении,
		ВыводитьОкноОжидания,,
		СкрыватьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФормуЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Не ПараметрыОповещения.ВыводитьОкноОжидания И Не ПараметрыОповещения.СкрыватьИнтерфейс Тогда
		Элементы.СтраницаДокументооборотДоступен.Доступность = Истина;
	КонецЕсли;
	
	ОбработатьФорму = Ложь;
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьОшибкиПриОбновленииФормы(
		ЭтотОбъект,
		Результат,
		ОбработатьФорму);
	Если ОбработатьФорму Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОперацияВыполнена(Результат, ОбработатьФорму) Тогда
		ОбновлениеНаСервереЗавершение(Результат.РезультатДлительнойОперации);
		ИнтеграцияС1СДокументооборот3Клиент.ПриОткрытииФормыДействия(ЭтотОбъект);
	ИначеЕсли ОбработатьФорму Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновлениеНаСервереЗавершение(ДействиеXDTOСтрока)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ДействиеXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СтрокаВОбъектXDTO(Прокси, ДействиеXDTOСтрока);
	ОбработатьОтветВебСервисаНаПолучениеДействия(ДействиеXDTO);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписатьОбъект

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	Если Не ЗначениеЗаполнено(ID) Или Не ЗначениеЗаполнено(Тип) Тогда
		Закрыть(КодВозвратаДиалога.Отмена);
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Если РежимДиалога Тогда
			Закрыть(КодВозвратаДиалога.ОК);
		Иначе
			Закрыть(КодВозвратаДиалога.Отмена);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборот3Клиент.ПроверитьУчастниковИЗаписатьДействие(
		ПодготовитьДействиеДляЗаписи(),
		ЭтотОбъект,
		Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	ОбработатьФорму = Ложь;
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОперацияВыполнена(Результат, ОбработатьФорму) Тогда
		Модифицированность = Ложь;
		ДанныеОбработки = Новый Структура("ПредметID, ПредметТип", ОсновнойПредметID, ОсновнойПредметТип);
		Оповестить("Документооборот_ДействиеСОбработкой", Новый Структура("ДанныеОбработки", ДанныеОбработки), ЭтотОбъект);
		Закрыть();
	ИначеЕсли ОбработатьФорму Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
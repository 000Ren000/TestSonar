﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
	ЗаполнитьКонтекстОтправкиПриСоздании();
	
	Если Не ЗначениеЗаполнено(КонтекстОтправки.ДокументОснование) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ДокументОснование = КонтекстОтправки.ДокументОснование;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Документы, "ДокументОснование", ДокументОснование, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	НастроитьЭлементыФормы();
	
	ИмяОбъектаМетаданныхОснования = ДокументОснование.Метаданные().ПолноеИмя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", ДокументОснование);
	
	ФормаОснования = ПолучитьФорму(ИмяОбъектаМетаданныхОснования + ".ФормаОбъекта", ПараметрыФормы);
	
	Если ФормаОснования = Неопределено Тогда
		ИмяФормыОснования = "";
	Иначе
		ИмяФормыОснования = ФормаОснования.ИмяФормы;
	КонецЕсли;
	
	ИнициализироватьКомандыОтправкиПечатныхФорм(ИмяФормыОснования);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ИнтерфейсДокументовЭДОКлиент.ИмяСобытияОбновленияТекущихДелЭДО() Тогда
		Элементы.Документы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументы

&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Посмотреть(Команда)
	ТекущиеДанные = Элементы.Документы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоУмолчанию(Команда)
	
	ИнтерфейсДокументовЭДОКлиент.СформироватьНеформализованныеЭДОПоКонтекстуОтправки(КонтекстОтправки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКонтекстОтправкиПриСоздании()
	
	Контекст = ИнтерфейсДокументовЭДОКлиентСервер.НовыйКонтекстОтправкиПечатныхФормПоЭДО();
	
	Если Параметры.Свойство("ДокументОснование") Тогда
		Контекст.ДокументОснование = Параметры.ДокументОснование;
	КонецЕсли;
	
	Если Параметры.Свойство("ДанныеПечатныхФорм") И ТипЗнч(Параметры.ДанныеПечатныхФорм) = Тип("Массив") Тогда
		
		Для Каждого Данные Из Параметры.ДанныеПечатныхФорм Цикл
			
			ДанныеКонтекста = ИнтерфейсДокументовЭДОКлиентСервер.НовыеДанныеПечатнойФормыДляНеформализованногоЭДО();
			ЗаполнитьЗначенияСвойств(ДанныеКонтекста, Данные);
			
			Контекст.ДанныеПечатныхФорм.Добавить(ДанныеКонтекста);
			
		КонецЦикла;
		
	КонецЕсли;
	
	КонтекстОтправки = Новый ФиксированнаяСтруктура(Контекст);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	Элементы.ПояснениеНадпись.Заголовок = СтрШаблон(
		НСтр("ru = 'Для документа %1 уже имеются сформированные документы ЭДО. Перед отправкой нового документа убедитесь, что не произойдет дублирования документов.'"),
		ДокументОснование);
	
	Если КонтекстОтправки.ДанныеПечатныхФорм.Количество() = 0 Тогда
		
		Элементы.ОтправитьПоУмолчанию.Видимость = Ложь;
		
	ИначеЕсли КонтекстОтправки.ДанныеПечатныхФорм.Количество() = 1 Тогда
		
		ДанныеПечатнойФормы = КонтекстОтправки.ДанныеПечатныхФорм[0];
		
		Элементы.ОтправитьПоУмолчанию.Заголовок = СтрШаблон(
			НСтр("ru = 'Отправить как ""%1""'"),
			ДанныеПечатнойФормы.НаименованиеФайла);
		
	Иначе
		
		Элементы.ОтправитьПоУмолчанию.Заголовок = СтрокаСЧислом(
			НСтр("ru = ';Отправить %1 документ; ;Отправить %1 документа;Отправить %1 документов;Отправить %1 документов'"),
			КонтекстОтправки.ДанныеПечатныхФорм.Количество(), ВидЧисловогоЗначения.Количественное);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомандыОтправкиПечатныхФорм(ИмяФормыОснования)

	КомандыПечати = ИнтеграцияЭДО.КомандыПечатиДляОтправкиНеформализованногоЭДО(
		ДокументОснование.Метаданные(), ИмяФормыОснования);
	КомандыПечатиВСериализуемомВиде = ОбщегоНазначения.ТаблицаЗначенийВМассив(КомандыПечати);
	ОписанияКомандПечатиПоИмениКомандыФормы = Новый Соответствие;
	Для Каждого ОписаниеКомандыПечати Из КомандыПечатиВСериализуемомВиде Цикл
		КомандаОтправитьКак = НоваяКомандаОтправитьКак(ОписаниеКомандыПечати.Представление);
		ДобавитьКнопкуДляКомандыОтправитьКак(КомандаОтправитьКак);
		ОписанияКомандПечатиПоИмениКомандыФормы.Вставить(КомандаОтправитьКак.Имя, ОписаниеКомандыПечати);
	КонецЦикла;
	КоллекцияКомандПечатиОснования = Новый ФиксированноеСоответствие(ОписанияКомандПечатиПоИмениКомандыФормы);

КонецПроцедуры

&НаСервере
Функция НоваяКомандаОтправитьКак(Представление)
	Действие = "Подключаемый_ОтправитьКак";
	СлучайноеИмя = Действие + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	НоваяКоманда = Команды.Добавить(СлучайноеИмя);
	НоваяКоманда.Заголовок = Представление;
	НоваяКоманда.Действие = Действие;
	Возврат НоваяКоманда;
КонецФункции

&НаСервере
Процедура ДобавитьКнопкуДляКомандыОтправитьКак(Команда)
	НоваяКнопка = Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), Элементы.ОтправитьКакПодменю);
	НоваяКнопка.ИмяКоманды = Команда.Имя;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтправитьКак(Команда)

	ОписаниеКоманды = КоллекцияКомандПечатиОснования[Команда.Имя];
	Если ОписаниеКоманды <> Неопределено Тогда
		ИнтерфейсДокументовЭДОКлиент.СформироватьНеформализованныйЭДОПоКомандеПечати(
			ОписаниеКоманды, ДокументОснование);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
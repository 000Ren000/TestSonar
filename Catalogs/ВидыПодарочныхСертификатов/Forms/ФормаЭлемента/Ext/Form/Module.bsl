﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Валюта = ВалютаРегламентированногоУчета(Объект.Организация);
		Объект.Бессрочный = Истина;
		Объект.ЧастичнаяОплата = Истина;
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементаФормыОрганизация();
	УстановитьВидимостьЭлементаФормыСтатьяДДС();
	УстановитьВидимостьЭлементаФормыГруппаФинансовогоУчета();
	УстановитьВидимостьЭлементаФормыГруппаПериодДействия();
	УстановитьДоступностьЭлементаФормыСегментНоменклатуры();
	
	Если Объект.ЧастичнаяОплата Тогда
		Элементы.ПодсказкаЧастичнаяОплата.Видимость = Ложь;
	Иначе
		Элементы.ПодсказкаЧастичнаяОплата.Видимость = Истина;;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Бессрочный Тогда
        ТекущийОбъект.КоличествоПериодовДействия = 999;
        ТекущийОбъект.ПериодДействия = ПредопределенноеЗначение("Перечисление.Периодичность.Год");
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриСозданииЧтенииНаСервере();

	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИспользоватьСегментыНоменклатуры = 1 И Не ЗначениеЗаполнено(Объект.СегментНоменклатуры) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Нстр("ru = 'Поле ""Сегмент номенклатуры"" не заполнено.'"),,"Объект.СегментНоменклатуры",, Отказ);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьИндивидуальныйШаблонЭтикеткаПриИзменении(Элемент)
	
	Объект.СегментНоменклатуры = ПредопределенноеЗначение("Справочник.СегментыНоменклатуры.ПустаяСсылка");
	ИспользоватьСегментыНоменклатуры = (ИспользоватьСегментыНоменклатуры = 1);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СегментНоменклатуры","Доступность", (ИспользоватьСегментыНоменклатуры = 1));

КонецПроцедуры

&НаКлиенте
Процедура ТипКартыПриИзменении(Элемент)
	
	ТипКартыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипКартыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяОплатаПереключательПриИзменении(Элемент)
	
	Если ЧастичнаяОплатаПереключатель = "РазрешитьЧастичнуюОплату" Тогда
		Объект.ЧастичнаяОплата = Истина;
		Элементы.ПодсказкаЧастичнаяОплата.Видимость = Ложь;	
	Иначе
		Объект.ЧастичнаяОплата = Ложь;	
		Элементы.ПодсказкаЧастичнаяОплата.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаНастройкаСчетовУчетаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Возврат; // В УТ обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура УчетПодарочныхСертификатов2_5ПриИзменении(Элемент)
	
	Если Объект.УчетПодарочныхСертификатов2_5 Тогда
		Объект.СегментНоменклатуры = Неопределено;
		ИспользоватьСегментыНоменклатуры = 0;
	КонецЕсли;
	
	УстановитьВидимостьЭлементаФормыОрганизация();
	УстановитьВидимостьЭлементаФормыСтатьяДДС();
	УстановитьВидимостьЭлементаФормыГруппаФинансовогоУчета();
	УстановитьДоступностьЭлементаФормыСегментНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура БессрочныйПриИзменении(Элемент)

    Если НЕ Объект.Бессрочный Тогда
        Объект.КоличествоПериодовДействия = 1;
    КонецЕсли;
    
    УстановитьВидимостьЭлементаФормыГруппаПериодДействия()

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ПараметрыРедактирования = ОбщегоНазначенияУТКлиент.ПараметрыРазрешенияРедактированияРеквизитовОбъекта();
	ПараметрыРедактирования.ТолькоВидимые = Ложь;
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект, ПараметрыРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТолькоВидимые", Ложь);
		ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
		
		ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ТипКартыПриИзмененииНаСервере()
	
	Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовПодарочныхСертификатовДлинаМагнитногоКода.Видимость           = Видимость;
	Элементы.ШаблоныКодовПодарочныхСертификатовНачалоДиапазонаМагнитногоКода.Видимость = Видимость;
	Элементы.ШаблоныКодовПодарочныхСертификатовКонецДиапазонаМагнитногоКода.Видимость  = Видимость;
	Элементы.ШаблоныКодовПодарочныхСертификатовШаблонКодаМагнитнойКарты.Видимость      = Видимость;
	
	Видимость = Объект.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Объект.ТипКарты = Перечисления.ТипыКарт.Смешанная;
	Элементы.ШаблоныКодовПодарочныхСертификатовДлинаШтрихкода.Видимость           = Видимость;
	Элементы.ШаблоныКодовПодарочныхСертификатовНачалоДиапазонаШтрихкода.Видимость = Видимость;
	Элементы.ШаблоныКодовПодарочныхСертификатовКонецДиапазонаШтрихкода.Видимость  = Видимость;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодсистемыСвойств

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьВидимостьЭлементаФормыОрганизация()
	
	Элементы.Организация.Видимость = Объект.УчетПодарочныхСертификатов2_5;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементаФормыСтатьяДДС()
	
	Элементы.СтатьяДвиженияДенежныхСредствПродажа.Видимость = Объект.УчетПодарочныхСертификатов2_5;
	Элементы.СтатьяДвиженияДенежныхСредствВозврат.Видимость = Объект.УчетПодарочныхСертификатов2_5;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементаФормыГруппаФинансовогоУчета()
	
	Элементы.ГруппаФинансовогоУчета.Видимость = Объект.УчетПодарочныхСертификатов2_5;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементаФормыГруппаПериодДействия()     
	
	Элементы.ГруппаПериодДействия.Видимость = НЕ Объект.Бессрочный;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементаФормыСегментНоменклатуры()
	
	Элементы.ГруппаСегментНоменклатурыЛево.ТолькоПросмотр = Объект.УчетПодарочныхСертификатов2_5;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВалютаРегламентированногоУчета(Организация)
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию();
	Если ЗначениеЗаполнено(Организация) Тогда
		ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Возврат ВалютаРегламентированногоУчета;
КонецФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ТипКартыПриИзмененииНаСервере();
	
	Если Объект.ЧастичнаяОплата Тогда
		ЧастичнаяОплатаПереключатель = "РазрешитьЧастичнуюОплату";
	Иначе
		ЧастичнаяОплатаПереключатель = "ЗапретитьЧастичнуюОплату";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СегментНоменклатуры) Тогда
		ИспользоватьСегментыНоменклатуры = 1;
	Иначе
		ИспользоватьСегментыНоменклатуры = 0;
	КонецЕсли;
	
	
	Если Объект.УчетПодарочныхСертификатов2_5 Тогда
		ТекстГиперссылки = Новый ФорматированнаяСтрока("Настроить счета учета по организации", , ЦветаСтиля.ГиперссылкаЦвет, ,"ОткрытьРабочееМестоНастроекСчетовУчета");
		ЭтотОбъект.НастройкаСчетовУчета_Ссылка = ТекстГиперссылки;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СегментНоменклатуры","Доступность", (ИспользоватьСегментыНоменклатуры = 1));
	
	Элементы.ГруппаСегментНоменклатурыЛево.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьСегментыНоменклатуры");
	Элементы.УчетПодарочныхСертификатов2_5.Видимость = ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов");
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.Валюта = ВалютаРегламентированногоУчета(Объект.Организация);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

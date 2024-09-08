﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураНастроек") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СтруктураНастроек);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		
		Если СмещениеПериода >= 0 Тогда
		
			НаправлениеСмещения = 1;
			СмещениеРедактируемое = СмещениеПериода;
		
		Иначе
		
			НаправлениеСмещения = -1;
			СмещениеРедактируемое = НаправлениеСмещения * СмещениеПериода;
		
		КонецЕсли; 
		
	КонецЕсли;
	
	ПериодПланПредставление = СформироватьПредставлениеПериода(Новый Структура("Периодичность, НачалоПериода, ОкончаниеПериода", 
		Периодичность, НачалоПериодаПлан, ОкончаниеПериодаПлан));
	
	ПриИзмененииСмещения(ЭтотОбъект);
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СмещениеПериодаПриИзменении(Элемент)
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура НаправлениеСмещенияПриИзменении(Элемент)
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантСмещениеПериодаПриИзменении(Элемент)
	
	ПриИзмененииСмещения(ЭтотОбъект);
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьИЗакрыть(Команда)
	
	СмещениеПериода = НаправлениеСмещения * СмещениеРедактируемое;
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	
	СохранитьНастройки();
	Закрыть(СтруктураНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеПериода(Параметры) 

	Представление = "";
	
	НачалоПериода 		= Параметры.НачалоПериода;
	ОкончаниеПериода	= Параметры.ОкончаниеПериода;
	Периодичность 		= Параметры.Периодичность;
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	#Иначе 
		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли
		
	ПланированиеКлиентСервер.УстановитьНачалоОкончаниеПериодаПлана(Периодичность, НачалоПериода, ОкончаниеПериода, ТекущаяДатаСеанса);
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		ФорматПериодичностьМесяц = НСтр("ru = 'ДФ=''ММММ гггг'''");
		Если НачалоМесяца(НачалоПериода) = НачалоМесяца(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, ФорматПериодичностьМесяц);
		Иначе
			Представление = Формат(НачалоПериода, ФорматПериодичностьМесяц) + " - " + Формат(ОкончаниеПериода, ФорматПериодичностьМесяц);
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		ФорматПериодичностьДень = "ДЛФ=DD";
		Если НачалоДня(НачалоПериода) = НачалоДня(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, ФорматПериодичностьДень);
		Иначе
			Представление = Формат(НачалоПериода, ФорматПериодичностьДень) + " - " + Формат(ОкончаниеПериода, ФорматПериодичностьДень);
		КонецЕсли;
		
	Иначе
		
		Представление = Формат(НачалоПериода, "ДЛФ=DD") + " - " + Формат(ОкончаниеПериода, "ДЛФ=DD");
		
	КонецЕсли;
	
	Возврат Представление;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьНачалоПериода(НачалоПериода, Периодичность, Знач Смещение, Знач НаправлениеСмещения)
	
	Смещение = НаправлениеСмещения * Смещение;
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСервер.РассчитатьДатуНачалаПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьОкончаниеПериода(НачалоПериода, Периодичность, Знач Смещение, Знач НаправлениеСмещения)
	
	Смещение = НаправлениеСмещения * Смещение;
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСервер.РассчитатьДатуОкончанияПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПериодПриИзмененииСмещения(Форма) 

	Форма.НачалоПериодаСмещенный = ПересчитатьНачалоПериода(Форма.НачалоПериодаПлан, Форма.Периодичность, Форма.СмещениеРедактируемое, Форма.НаправлениеСмещения);
	Форма.ОкончаниеПериодаСмещенный = ПересчитатьОкончаниеПериода(Форма.ОкончаниеПериодаПлан, Форма.Периодичность, Форма.СмещениеРедактируемое, Форма.НаправлениеСмещения);
	
	УстановитьПериодПрописью(Форма.СмещениеРедактируемое, Форма.Периодичность, Форма.ПериодичностьПредставление);
	
	Форма.ПериодСмещенныйПредставление = СформироватьПредставлениеПериода(Новый Структура("Периодичность, НачалоПериода, ОкончаниеПериода", 
																Форма.Периодичность, Форма.НачалоПериодаСмещенный, Форма.ОкончаниеПериодаСмещенный));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииСмещения(Форма)

	Если Форма.ВариантСмещения = "Произвольное" Тогда
		Форма.Элементы.Смещение.Доступность = Истина;
		Форма.Элементы.НаправлениеСмещения.Доступность = Истина;
	Иначе
		Форма.Элементы.Смещение.Доступность = Ложь;
		Форма.Элементы.НаправлениеСмещения.Доступность = Ложь;
	КонецЕсли;
	
	Если Форма.ВариантСмещения = "ПредыдущийПериод" Тогда
		Форма.СмещениеРедактируемое = 1;
		Форма.НаправлениеСмещения = -1;
	ИначеЕсли Форма.ВариантСмещения = "ТекущийПериод" Тогда
		Форма.СмещениеРедактируемое = 0;
		Форма.НаправлениеСмещения = -1;
	ИначеЕсли Форма.ВариантСмещения = "ПредыдущийГод" Тогда
		
		Форма.НаправлениеСмещения = -1;
		
		Если Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			Форма.СмещениеРедактируемое = 12;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
			Форма.СмещениеРедактируемое = ДеньГода(КонецГода(Форма.НачалоПериодаПлан));
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
			Форма.СмещениеРедактируемое = НеделяГода(КонецГода(Форма.НачалоПериодаПлан)) - 1;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
			Форма.СмещениеРедактируемое = 36;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			Форма.СмещениеРедактируемое = 4;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			Форма.СмещениеРедактируемое = 2;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			Форма.СмещениеРедактируемое = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПериодПрописью(Смещение, Периодичность, ПериодичностьПредставление)

	ПериодичностьПредставление = МониторингЦелевыхПоказателейКлиентСервер.ПериодПрописью(Смещение, Периодичность);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки()
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	СохранитьНастройкиНаСервере(СтруктураНастроек, ТипПлана);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиНаСервере(СтруктураНастроек, ТипПлана)
	
	КлючОбъекта = "НастройкиРаботыПользователя" + ТипПлана;
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, "СтруктураНастроек", СтруктураНастроек);
	
КонецПроцедуры

#КонецОбласти